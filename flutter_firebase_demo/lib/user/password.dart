import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/dialog/dialog.dart';
import 'package:flutter_firebase_demo/general/back.dart';
import 'package:flutter_firebase_demo/general/message_type.dart';
import 'package:flutter_firebase_demo/user/password_operation.dart';

class Password extends StatefulWidget {
  final PasswordOperation operation;

  Password(this.operation);

  @override
  State<StatefulWidget> createState() => _PasswordState(operation);
}

class _PasswordState extends State<Password> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  final PasswordOperation operation;
  String pageTitle;
  String buttonText;

  _PasswordState(this.operation);

  @override
  void initState() {
    if (this.operation == PasswordOperation.forgotPassowrd) {
      this.pageTitle = "Forgot Password";
      this.buttonText = "Reset Password";
    } else {
      this.pageTitle = "Change Password";
      this.buttonText = "Change Password";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          back(context);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(this.pageTitle),
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
        child: ListView(children: getPasswordForm(this.operation)),
      ),
    );
  }

//Add record to the firebase database.
  Future<Null> resetPassword() async {
    String userName = userNameController.text.trim();
    String password = passwordController.text.trim();

    debugPrint("Name: $userName, Password: $password");

//Get the firebase database collection refrence of the baby collection.
    CollectionReference reference = Firestore.instance.collection('User');
    var users = await reference
        .where("email", isEqualTo: userName.toLowerCase())
        .getDocuments();

    if (users.documents.length == 0) {
      try {
        users = await reference
            .where("phoneNo", isEqualTo: int.parse(userName))
            .getDocuments();
      } catch (e, s) {
        print(e);
        print(s);
      }
    }

    back(context); //Stop progress bar

    if (users.documents.length > 0) {
      await showMessageDialog(
          context: context,
          title: "Password Reset",
          message: "Password changed successfully.",
          type: MessageType.success);
      back(context); //Re-direc to sign in page
    } else {
      await showMessageDialog(
          context: context,
          title: "Password Reset",
          message: "Invalid User Name, Please try again later.",
          type: MessageType.error);
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

  getCurrentPasswordTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14.0),
      obscureText: true,
      controller: passwordController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Current Password Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Current Password",
          hintText: "Please Enter Current Password",
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

  getRePasswordTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14.0),
      obscureText: true,
      controller: rePasswordController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Re-Password Required";
        } else if (passwordController.text != value) {
          return "Password do not match";
        }
      },
      decoration: InputDecoration(
          labelText: "Re-Password",
          hintText: "Please Enter Re-Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getResetPasswordnButton() {
    return Padding(
        padding:
            EdgeInsets.only(top: 10.0, bottom: 10.0, left: 50.0, right: 50.0),
        child: RaisedButton(
          child: Text(
            this.buttonText,
            textScaleFactor: 1.5,
          ),
          onPressed: () async {
            showCircularProgressBar(context);
            setState(() async {
              if (_formKey.currentState.validate()) {
                debugPrint("Reset Password Clicked");
                await resetPassword();
              } else {
                back(context);
              }
            });
          },
        ));
  }

  getPasswordForm(PasswordOperation operation) {
    if (operation == PasswordOperation.forgotPassowrd) {
      return <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: getUserNameTextField()),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: getPasswordTextField()),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: getRePasswordTextField()),
        getResetPasswordnButton()
      ];
    }

    return <Widget>[
      Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: getUserNameTextField()),
      Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: getCurrentPasswordTextField()),
      Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: getPasswordTextField()),
      Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: getRePasswordTextField()),
      getResetPasswordnButton()
    ];
  }
}
