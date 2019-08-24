import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/dialog/dialog.dart';
import 'package:flutter_firebase_demo/general/message_type.dart';
import 'package:flutter_firebase_demo/menu/normal_menu.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_firebase_demo/user/current_user.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class BookTicket extends StatefulWidget {
  final String busInfo; //Bus Name, Busnumber

  BookTicket(this.busInfo);

  @override
  State<StatefulWidget> createState() => _BookState(this.busInfo);
}

class _BookState extends State<BookTicket> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<AutoCompleteTextFieldState<String>> busNumberTextFieldKey =
      GlobalKey();
  TextEditingController busInfoController = TextEditingController();
  final TextEditingController _sourceTypeAheadController =
      TextEditingController();
  TextEditingController _destinationTypeAheadController =
      TextEditingController();
  TextEditingController fairController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  String _selectedCity;
  final String busInfo;

  _BookState(this.busInfo);

  @override
  void initState() {
    busInfoController.text = this.busInfo;
    /*CollectionReference reference = Firestore.instance.collection('Bus');
    reference.getDocuments().then((snapshot) {
      snapshot.documents.forEach((document) {
        busNumbers.add(document["name"] + "," + document["number"]);
      });
    }).catchError((e, s) {
      print(e);
      print(s);
    });*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            debugPrint("Book Ticket Navigation.");
            return NormalMenu(userType: CurrentUser.userType);
          }));
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Pay Amount"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    debugPrint("Book Ticket Navigation.");
                    return NormalMenu(userType: CurrentUser.userType);
                  }));
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
                child: getBusInfoTextField()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getSourceTypeAheadField()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getDestinationTypeAheadField()),
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
    String busNumber = busInfoController.text;
    String source = _sourceTypeAheadController.text;
    String destination = _destinationTypeAheadController.text;
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

  getBusInfoTextField() {
    return TextFormField(
      enabled: false,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14.0),
      textInputAction: TextInputAction.next,
      controller: busInfoController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Bus Information Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Bus Information",
          hintText: "Please Enter Bus Information",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getSourceTypeAheadField() {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: this._sourceTypeAheadController,
          decoration: InputDecoration(labelText: 'Source')),
      suggestionsCallback: (pattern) {
        return getBusRoutes(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        this._sourceTypeAheadController.text = suggestion;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please select a city';
        } else if (value == "Not Available") {
          this._sourceTypeAheadController.text = "";
        }
      },
      onSaved: (value) => this._selectedCity = value,
    );
  }

  getDestinationTypeAheadField() {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: this._destinationTypeAheadController,
          decoration: InputDecoration(labelText: 'Destination')),
      suggestionsCallback: (pattern) {
        return getBusRoutes(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        if (suggestion == "Not Available") {
          this._destinationTypeAheadController.text = "";
        } else {
          this._destinationTypeAheadController.text = suggestion;
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please select a city';
        }
      },
      onSaved: (value) => this._selectedCity = value,
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

  Future<List<String>> getBusRoutes(String pattern) async {
    List<String> busRoutes = new List<String>();
    CollectionReference ref = Firestore.instance.collection('Route');
    var snapshot = await ref.getDocuments();
    snapshot.documents.forEach((documentSnapshot) {
      if (documentSnapshot["place"]
          .toLowerCase()
          .contains(pattern.toLowerCase())) {
        busRoutes.add(documentSnapshot["place"]);
      }
    });

    if (busRoutes.length == 0) {
      busRoutes.add("Not Available");
    }

    return busRoutes;
  }
}
