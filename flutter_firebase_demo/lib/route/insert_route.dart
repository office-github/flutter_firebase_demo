import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/dialog/dialog.dart';
import 'package:flutter_firebase_demo/general/message_type.dart';

class InsertRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RouteState();
}

class _RouteState extends State<InsertRoute> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController routeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          back(context);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Add Route Information"),
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
                child: getRouteTextField()),
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
                      showCircularProgressBar(context);
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
    String place = routeController.text.toUpperCase();

    debugPrint("Route: $place");

//Get the firebase database collection refrence of the baby collection.
    try {
      Firestore.instance
          .collection('Route')
          .where("place", isEqualTo: place)
          .getDocuments()
          .then((snapshot) {
        back(context);
        if (snapshot.documents.length > 0) {
          showMessageDialog(
              context: context,
              title: "Route",
              message: "Route Already Added.",
              type: MessageType.warning);
        } else {
          CollectionReference reference =
              Firestore.instance.collection('Route');
          Map<String, dynamic> map = new Map();
          map.addAll({
            "place": place,
          });
          reference.add(map);
          back(context);
          showMessageDialog(
                  context: context,
                  title: "Route",
                  message: "Route Added Successfylly",
                  type: MessageType.success)
              .then((s) {
            back(context);
          });
          debugPrint("Route Saved Successfully.");
        }
      });
    } catch (e, s) {
      print(e);
      print(s);
      showMessageDialog(
          context: context,
          title: "Bus Information",
          message: "Failed To Add Bus Information, Please try again.",
          type: MessageType.error);
    }
  }

  void back(BuildContext context) {
    Navigator.pop(context);
  }

  getRouteTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14.0),
      controller: routeController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Place Name Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Place Name",
          hintText: "Please Enter Place Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }
}
