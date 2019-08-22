import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/dialog/dialog.dart';
import 'package:flutter_firebase_demo/general/back.dart';
import 'package:flutter_firebase_demo/user/UserType.dart';
import 'package:flutter_firebase_demo/user/register.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          back(context);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Sign In"),
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
                child: getUserNameTextField()),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: getPasswordTextField()),
            Padding(
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 50.0, right: 50.0),
              child: RaisedButton(
                child: Text(
                  "Sign In",
                  textScaleFactor: 1.5,
                ),
                onPressed: () async {
                  showCircularProgressBar(context);
                  setState(() async {
                    if (_formKey.currentState.validate()) {
                      debugPrint("Sign In Clicked");
                      await signInUser();
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
  Future<Null> signInUser() async {
    String userName = userNameController.text.trim();
    String password = passwordController.text.trim();

    debugPrint("Name: $userName, Password: $password");

//Get the firebase database collection refrence of the baby collection.
    CollectionReference reference = Firestore.instance.collection('User');
    var users = await reference
        .where("email", isEqualTo: userName.toLowerCase())
        .where("password", isEqualTo: password)
        .getDocuments();

    if (users.documents.length == 0) {
      try {
        users = await reference
            .where("phoneNo", isEqualTo: int.parse(userName))
            .where("password", isEqualTo: password)
            .getDocuments();
      } catch (e, s) {
        print(e);
        print(s);
      }
    }

    if (users.documents.length > 0) {
      back(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        debugPrint("Signed In Successfully.");
        return Register(
          userType: users.documents[0].data[UserType.text],
        );
      }));
    }
  }

  getUserNameTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14.0, height: 1.0),
      controller: userNameController,
      validator: (String value) {
        if (value.isEmpty) {
          return "User Name Required";
        }
      },
      decoration: InputDecoration(
          labelText: "User Name",
          hintText: "Please Enter Email Or Phone No.",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getPasswordTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14.0),
      obscureText: true,
      controller: passwordController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Password Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Please Enter Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }
}
