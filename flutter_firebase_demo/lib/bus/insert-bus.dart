import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InsertBus extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BusState();
}

class _BusState extends State<InsertBus> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController idController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController routesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          back(context);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Add BUs Information"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  back(context);
                },
              ),
            ),
            body: getForm()));
  }

  Widget getForm() {
    return Form(
      key: _formKey,
      autovalidate: true,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getIdTextField()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getNumberDropDown()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getOwnerTextField()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getRoutesTextField()),
            Padding(
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 50.0, right: 50.0),
              child: RaisedButton(
                child: Text(
                  "Save",
                  textScaleFactor: 1.5,
                ),
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      debugPrint("Add Clicked");
                      save();
                    }
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

//Add record to the firebase database.
  void save() {
    int id = int.parse(idController.text);
    String number = numberController.text;
    String owner = ownerController.text;
    String routes = routesController.text;

    debugPrint("Name: $id, Vote: $number");

//Get the firebase database collection refrence of the baby collection.
    CollectionReference reference = Firestore.instance.collection('Bus');
    Map<String, dynamic> map = new Map();
    map.addAll({"id": id, "number": number, "owner": owner, "routes": routes});

    reference.add(map);
    debugPrint("Saved Successfully.");
  }

  void back(BuildContext context) {
    Navigator.pop(context);
  }

  getIdTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontStyle: FontStyle.normal, fontSize: 14.0),
      controller: idController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Id Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Id",
          hintText: "Please Enter Id",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      onEditingComplete: () {
        setState(() {
          if (_formKey.currentState.validate()) {
            print("Valid");
          }
        });
      },
    );
  }

  getNumberDropDown() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14.0),
      controller: numberController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Bus Number Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Bus Number",
          hintText: "Please Enter Bus Number",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getOwnerTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14.0),
      controller: ownerController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Owner Name Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Owner Name",
          hintText: "Please Enter Owner Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getRoutesTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 14.0),
      controller: routesController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Routes Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Routes",
          hintText: "Please Enter Routes e.g. Balkhu, Kalanki",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }
}
