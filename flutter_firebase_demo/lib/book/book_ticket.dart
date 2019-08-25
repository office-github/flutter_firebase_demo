import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
  TextEditingController journeyDateController = TextEditingController();
  TextEditingController fairController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  String _selectedCity;
  final String busInfo;

  _BookState(this.busInfo);

  @override
  void initState() {
    busInfoController.text = this.busInfo;
    List<String> busInfoAsList = this.busInfo.split(',');
    CollectionReference reference = Firestore.instance.collection('Bus');
    reference
        .where("number", isEqualTo: busInfoAsList[0])
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents.length > 0) {
        discountController.text = snapshot.documents[0].data["discount"];
      } else {
        discountController.text = "0.0";
      }

      fairController.addListener(() {
        //here you have the changes of your textfield
        print("value: ${fairController.text}");
        //use setState to rebuild the widget
        setState(() {
          double discount = discountController?.text == null
              ? 0.0
              : double.parse(discountController.text);
          double fair = fairController.text == "" || fairController.text == null
              ? 0.0
              : double.parse(fairController.text);

          if (discount > 0) {
            double total = fair * discount / 100;
            totalController.text = total.toString();
          } else {
            totalController.text = fairController.text;
          }
        });
      });
      super.initState();
    }).catchError((e, s) {
      print(e);
      print(s);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            debugPrint("Book Ticket Navigation.");
            return NormalMenu();
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
                    return NormalMenu();
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
            
            getJourneyDateTime(),
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
                      showCircularProgressBar(context);
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
    String userId = CurrentUser.email;
    String busId = busInfoController.text;
    String source = _sourceTypeAheadController.text;
    String destination = _destinationTypeAheadController.text;
    DateTime bookedDate = DateTime.now();
    DateTime journeyDate = DateTime.parse(journeyDateController.text);
    double fair = double.parse(fairController.text);
    double discount = double.parse(discountController.text);
    double totalFair = double.parse(totalController.text);

    debugPrint("userId: $userId, Bus Number: $busId");

//Get the firebase database collection refrence of the baby collection.
    Firestore.instance.runTransaction((transaction) async {
      final QuerySnapshot snapshot = await Firestore.instance
          .collection('User')
          .where("id", isEqualTo: CurrentUser.id)
          .getDocuments();

      CollectionReference reference = Firestore.instance.collection('Book');
      Map<String, dynamic> map = new Map();
      map.addAll({
        "id": id,
        "userId": userId,
        "busId": busId,
        "source": source,
        "destination": destination,
        "bookedDate": bookedDate,
        "journeyDate": journeyDate,
        "fair": fair,
        "discount": discount,
        "totalFair": totalFair
      });

      reference.add(map);

      if (snapshot.documents.length > 0) {
        double remainingFair = 0;
        double finalAmount = 0;
        double finalBonus = 0;

        if (CurrentUser.amount <= totalFair) {
          remainingFair = totalFair - CurrentUser.amount;
          finalAmount = 0;
          CurrentUser.amount = 0;
        }

        if (finalAmount == 0 && remainingFair > 0) {
          finalBonus = CurrentUser.bonus - remainingFair;
          CurrentUser.bonus = finalBonus;
        }

        await transaction.update(snapshot.documents[0].reference,
            {'amount': finalAmount, 'bonus': finalBonus});
      }
    }).whenComplete(() {
      debugPrint("Saved Successfully.");
      back(context);
      showMessageDialog(
              context: context,
              title: "Success",
              message: "Paid Successfully",
              type: MessageType.success)
          .then((u) {
        back(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          debugPrint("Sign In Navigation.");
          return NormalMenu();
        }));
      });
    }).catchError((e, s) {
      print(e);
      print(s);
      back(context);
      showMessageDialog(
          context: context,
          title: "Failed",
          message: "Pay Failed, Please Try again.",
          type: MessageType.error);
    });
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
        } else if (value == _destinationTypeAheadController.text) {
          return "Source and Destination Cannot be same";
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
        } else if (value == _sourceTypeAheadController.text) {
          return "Source and Destination Cannot be same";
        }
      },
      onSaved: (value) => this._selectedCity = value,
    );
  }

  getJourneyDateTime() {
    return GestureDetector(
        onTap: () {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime(2018, 3, 5), onChanged: (date) {
            print('change $date');
          }, onConfirm: (date) {
            journeyDateController.text = date.toString().substring(0, 16);
            print('confirm $date');
          }, currentTime: DateTime.now(), locale: LocaleType.en);
        },
        child: AbsorbPointer(
            child: TextFormField(
          controller: journeyDateController,
          decoration: InputDecoration(
              labelText: "Journey Date",
              hintText: "Please Enter Journey Date",
              icon: Icon(Icons.date_range),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        )));
  }

  getFairTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14.0),
      textInputAction: TextInputAction.next,
      controller: fairController,
      validator: (String value) {
        double total = CurrentUser.bonus + CurrentUser.amount;

        if (value.isEmpty) {
          return "Fair Required";
        } else if (double.parse(totalController.text) > total) {
          return "Insufficient Balance";
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
      enabled: false,
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
      enabled: false,
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
