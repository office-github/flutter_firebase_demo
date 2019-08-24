import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InsertBus extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BusState();
}

class _BusState extends State<InsertBus> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController numberController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController bonusController = TextEditingController();
  TextEditingController totalFairController = TextEditingController();
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
                child: getNumberTextField()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getNameTextField()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getOwnerTextField()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getDiscountTextField()),
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
    String number = numberController.text;
    String owner = ownerController.text;
    String name = nameController.text;
    double discount = double.parse(discountController.text);
    double bonus = double.parse(bonusController.text);
    double totalFair = double.parse(totalFairController.text);
    String routes = routesController.text;

    debugPrint("Bus Number: $number, Bus Routes: $routes");

//Get the firebase database collection refrence of the baby collection.
    CollectionReference reference = Firestore.instance.collection('Bus');
    Map<String, dynamic> map = new Map();
    map.addAll({
      "number": number,
      "owner": owner,
      "name": name,
      "discount": discount,
      "bonus": bonus,
      "totalFair": totalFair,
      "routes": routes
    });

    reference.add(map);
    debugPrint("Saved Successfully.");
  }

  void back(BuildContext context) {
    Navigator.pop(context);
  }

  getDiscountTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontStyle: FontStyle.normal, fontSize: 14.0),
      controller: discountController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Discount Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Discount(%)",
          hintText: "Please Enter Discount",
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

  getBonusTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontStyle: FontStyle.normal, fontSize: 14.0),
      controller: discountController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Bonus Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Bonus(%)",
          hintText: "Please Enter Bonus",
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

  getTotalFairTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontStyle: FontStyle.normal, fontSize: 14.0),
      controller: totalFairController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Total Fair Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Total Fair",
          hintText: "Please Enter Total Fair",
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

getNameTextField() {
  return TextFormField(
    keyboardType: TextInputType.number,
    style: TextStyle(fontSize: 14.0),
    controller: nameController,
    validator: (String value) {
      if (value.isEmpty) {
        return "Bus Name Required";
      }
    },
    decoration: InputDecoration(
        labelText: "Bus Name",
        hintText: "Please Enter Bus Name",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
  );
}

  getNumberTextField() {
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
