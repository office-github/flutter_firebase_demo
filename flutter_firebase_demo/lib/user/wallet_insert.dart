import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/dialog/dialog.dart';
import 'package:flutter_firebase_demo/general/back.dart';
import 'package:flutter_firebase_demo/general/message_type.dart';
import 'package:flutter_firebase_demo/user/current_user.dart';
import 'package:flutter_firebase_demo/user/password_operation.dart';
import 'package:flutter_firebase_demo/user/user_type.dart';

class InsertWallet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InsertWalletState();
}

class _InsertWalletState extends State<InsertWallet> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          back(context);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Add Money To Wallet"),
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
        child: ListView(children: getAddMoneyForm()),
      ),
    );
  }

//Add record to the firebase database.
  void addMoney() {
    double amount = double.parse(amountController.text.trim());

    debugPrint("User Email: ${CurrentUser.email}, Amount: $amount");

//Get the firebase database collection refrence of the baby collection.
    Firestore.instance.runTransaction((transaction) async {
      CollectionReference reference = Firestore.instance.collection('User');
      var snapshot = await reference
          .where("email", isEqualTo: CurrentUser.email.toLowerCase())
          .getDocuments();

      back(context); //Stop progress bar
      if (snapshot.documents.length > 0) {
        await transaction.update(snapshot.documents[0].reference, {
          'amount': amount + CurrentUser.amount
        });

        CurrentUser.amount = amount + CurrentUser.amount;
        await showMessageDialog(
            context: context,
            title: "Add Money To Wallet",
            message: "Money Added successfully.",
            type: MessageType.success);
      } else {
        await showMessageDialog(
            context: context,
            title: "Add Money To Wallet",
            message: "Invalid User Name.",
            type: MessageType.error);
      }
    }).catchError((error, s) {
      print(error);
      print(s);
      back(context);
      showMessageDialog(
            context: context,
            title: "Add Money To Wallet",
            message: "Failed, Please try again later.",
            type: MessageType.error);
    });
  }

  getAmountTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14.0, height: 1.0),
      controller: amountController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Amount Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Amount",
          hintText: "Please Enter Amount",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }


  getAddMoneyButton() {
    return Padding(
        padding:
            EdgeInsets.only(top: 10.0, bottom: 10.0, left: 50.0, right: 50.0),
        child: RaisedButton(
          child: Text(
            "Add Money",
            textScaleFactor: 1.5,
          ),
          onPressed: () async {
            showCircularProgressBar(context);
            setState(() async {
              if (_formKey.currentState.validate()) {
                debugPrint("Add Money Clicked");
                addMoney();
              } else {
                back(context);
              }
            });
          },
        ));
  }

  getAddMoneyForm() {
    return <Widget>[
      Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: getAmountTextField()),
      getAddMoneyButton()
    ];
  }
}
