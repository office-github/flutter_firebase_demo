import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/dialog/dialog.dart';
import 'package:flutter_firebase_demo/general/message_type.dart';
import 'package:flutter_firebase_demo/user/current_user.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class BookTicket extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookState();
}

class _BookState extends State<BookTicket> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<AutoCompleteTextFieldState<String>> busNumberTextFieldKey =
      GlobalKey();
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController fairController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController busNumberController = TextEditingController();
  AutoCompleteTextField<String> busNumberFilerField;
  List<String> busNumbers = List<String>();

  @override
  void initState() {
    CollectionReference reference = Firestore.instance.collection('Bus');
    reference.getDocuments().then((snapshot) {
      snapshot.documents.forEach((document) {
        busNumbers.add(document["number"]);
      });
    }).catchError((e, s) {
      print(e + s);
    });
    super.initState();
  }

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
                child: getBusNumberAutoCompleteTextField()),
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
    int id = 0;
    int userId = CurrentUser.id;
    String busNumber = busNumberController.text;
    String source = sourceController.text;
    String destination = destinationController.text;
    double fair = double.parse(fairController.text);
    double discount = double.parse(discountController.text);
    double totalFair = double.parse(totalController.text);

    debugPrint("userId: $userId, Bus Number: $busNumber");

//Get the firebase database collection refrence of the baby collection.
    /*CollectionReference reference = Firestore.instance.collection('Book');
    Map<String, dynamic> map = new Map();
    map.addAll({
      "id": id,
      "userId": userId,
      "busNumber": busNumber,
      "source": source,
      "destination": destination,
      "fair": fair,
      "discount": discount,
      "totalFair": totalFair
    });

    reference.add(map);
    debugPrint("Saved Successfully.");
    back(context);
    showMessageDialog(
        context: context,
        title: "Success",
        message: "Registration Successful",
        type: MessageType.success);*/
  }

  void back(BuildContext context) {
    Navigator.pop(context);
  }

  getBusNumberAutoCompleteTextField() {
    return busNumberFilerField = AutoCompleteTextField<String>(
      key: busNumberTextFieldKey,
      clearOnSubmit: false,
      suggestions: busNumbers,
      style: TextStyle(color: Colors.black, fontSize: 14),
      decoration: InputDecoration(
          labelText: "Bus Number",
          hintText: "Please Enter Bus Number",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      controller: busNumberController,
      itemFilter: (item, query) {
        return item.toLowerCase().contains(query.toLowerCase());
      },
      itemSorter: (a, b) {
        return a.toLowerCase().compareTo(b.toLowerCase());
      },
      itemSubmitted: (item) {
        setState(() {
          busNumberController.text = item;
        });
      },
      itemBuilder: (context, item) {
        return row(item);
      },
    );
  }

  Widget row(String busNumber) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          busNumber,
          style: TextStyle(fontSize: 14),
        )
      ],
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
