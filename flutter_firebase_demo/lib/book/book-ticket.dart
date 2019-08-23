import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookTicket extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookState();
}

class _BookState extends State<BookTicket> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController idController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController busIdController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController fairController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          back(context);
        },
        child: Scaffold(body: getForm()));
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
                child: getUserIdTextField()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getBusIdTextField()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getSourceTextField()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getDestinationTextField()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getFairTextField()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getDiscountTextField()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getTotalFairTextField()),
            Padding(
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 50.0, right: 50.0),
              child: RaisedButton(
                child: Text(
                  "Pay",
                  textScaleFactor: 1.5,
                ),
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      debugPrint("Pay Clicked");
                      payFair();
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
  void payFair() {
    int id = int.parse(idController.text);
    int userId = int.parse(userIdController.text);
    int busId = int.parse(busIdController.text);
    String source = sourceController.text;
    String destination = destinationController.text;
    double fair = double.parse(fairController.text);
    double discount = double.parse(discountController.text);
    double totalFair = double.parse(totalController.text);

    debugPrint("Name: $id, Vote: $totalFair");

//Get the firebase database collection refrence of the baby collection.
    CollectionReference reference = Firestore.instance.collection('Book');
    Map<String, dynamic> map = new Map();
    map.addAll({
      "id": id,
      "userId": userId,
      "busId": busId,
      "source": source,
      "destination": destination,
      "fair": fair,
      "discount": discount,
      "totalFair": totalFair
    });

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
      textInputAction: TextInputAction.next,
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

  getUserIdTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14.0),
      textInputAction: TextInputAction.next,
      controller: userIdController,
      validator: (String value) {
        if (value.isEmpty) {
          return "User Id Required";
        }
      },
      decoration: InputDecoration(
          labelText: "User Id",
          hintText: "Please Enter User Id",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getBusIdTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14.0),
      textInputAction: TextInputAction.next,
      controller: busIdController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Bud Id Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Bus Id",
          hintText: "Please Enter Bus Id",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getSourceTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14.0),
      textInputAction: TextInputAction.next,
      controller: sourceController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Source Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Source",
          hintText: "Please Enter Source",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getDestinationTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14.0),
      textInputAction: TextInputAction.next,
      controller: destinationController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Destination Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Destination",
          hintText: "Please Enter Destination",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getFairTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14.0),
      textInputAction: TextInputAction.next,
      controller: fairController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Fair Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Fair",
          hintText: "Please Enter Fair",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getDiscountTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14.0),
      textInputAction: TextInputAction.next,
      controller: discountController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Discount Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Discount",
          hintText: "Please Enter Discount",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getTotalFairTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14.0),
      textInputAction: TextInputAction.done,
      controller: totalController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Total Fair Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Total Fair",
          hintText: "Please Enter Total Fair",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }
}
