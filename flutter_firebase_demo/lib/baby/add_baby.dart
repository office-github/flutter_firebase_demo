import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Baby extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BabyState();
}

class _BabyState extends State<Baby> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController voteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          back(context);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Add Baby Information"),
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
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                style: TextStyle(fontStyle: FontStyle.normal, fontSize: 14.0),
                controller: nameController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Please provide name";
                  }
                },
                decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Enter Name e.g. Bijay",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                onEditingComplete: () {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      print("Valid");
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 14.0),
                controller: voteController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Please provide vote";
                  }
                },
                decoration: InputDecoration(
                    labelText: "Vote",
                    hintText: "Please Enter Vote e.g. 1",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
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
    String name = nameController.text;
    int vote = int.parse(voteController.text);

    debugPrint("Name: $name, Vote: $vote");

//Get the firebase database collection refrence of the baby collection.
    CollectionReference reference = Firestore.instance.collection('baby');
    Map<String, dynamic> map = new Map();
    map.addAll({"name": name, "votes": vote});

    reference.add(map);
  }

  void back(BuildContext context) {
    Navigator.pop(context);
  }
}
