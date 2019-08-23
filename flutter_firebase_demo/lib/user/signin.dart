import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_demo/dialog/dialog.dart';
import 'package:flutter_firebase_demo/general/back.dart';
import 'package:flutter_firebase_demo/general/message-type.dart';
import 'package:flutter_firebase_demo/menu/gridview-menu.dart';
import 'package:flutter_firebase_demo/menu/normal-menu.dart';
import 'package:flutter_firebase_demo/user/UserType.dart';
import 'package:flutter_firebase_demo/user/current-user.dart';
import 'package:flutter_firebase_demo/user/password-operation.dart';
import 'package:flutter_firebase_demo/user/password.dart';
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
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Sign In"),
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
            getSignInButton(),
            getForgotPasswordButton(),
            getRegisterButton()
          ],
        ),
      ),
    );
  }

//Add record to the firebase database.
  void signInUser() {
    String userName = userNameController.text.trim();
    String password = passwordController.text.trim();

    debugPrint("Name: $userName, Password: $password");

//Get the firebase database collection refrence of the baby collection.
    /*CollectionReference reference = Firestore.instance.collection('User');
    reference
        .where("email", isEqualTo: userName.toLowerCase())
        .where("password", isEqualTo: password)
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents.length > 0) {
        CurrentUser.id = snapshot.documents[0].data["id"];
        CurrentUser.userType = snapshot.documents[0].data[UserType.text];
        CurrentUser.userName = snapshot.documents[0].data["userName"];
        redirectToPage();
      } else {
        reference
            .where("phoneNo", isEqualTo: int.parse(userName))
            .where("password", isEqualTo: password)
            .getDocuments()
            .then((snapshot) {
          if (snapshot.documents.length > 0) {
            CurrentUser.id = snapshot.documents[0].data["id"];
            CurrentUser.userType = snapshot.documents[0].data[UserType.text];
            CurrentUser.userName = snapshot.documents[0].data["userName"];
            redirectToPage();
          } else {
            back(context);
            showMessageDialog(
                context: context,
                title: "Sign In Error",
                message: "Invalid User Name or Password",
                type: MessageType.error);
          }
        });
      }
    }).catchError((e, s) {
      print(e + s);
      back(context);
      showMessageDialog(
          context: context,
          title: "Sign In Error",
          message: "Error occured. Please try again later.",
          type: MessageType.error);
    });
*/
    CurrentUser.id = 1;
    CurrentUser.userName = "a@a.com";
    CurrentUser.userType = UserType.user;
    redirectToPage();
  }

  redirectToPage() {
    passwordController.text = "";
    back(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      debugPrint("Signed In Successfully.");
      return NormalMenu(userType: UserType.user);
      //return NormalMenu(userType: users.documents[0].data[UserType.text]);
      //return GridViewMenu();
    }));
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

  getSignInButton() {
    return Padding(
        padding:
            EdgeInsets.only(top: 10.0, bottom: 10.0, left: 50.0, right: 50.0),
        child: RaisedButton(
          child: Text(
            "Sign In",
            textScaleFactor: 1.5,
          ),
          onPressed: () async {
            setState(() {
              if (_formKey.currentState.validate()) {
                showCircularProgressBar(context);
                debugPrint("Sign In Clicked");
                signInUser();
              }
            });
          },
        ));
  }

  getForgotPasswordButton() {
    return Padding(
        padding: EdgeInsets.only(left: 50.0, right: 50.0),
        child: FlatButton(
          child: Text("Forgot Password"),
          onPressed: () async {
            debugPrint("Forgot Password Clicked");
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              passwordController.text = "";
              return Password(PasswordOperation.forgotPassowrd);
            }));
          },
        ));
  }

  getRegisterButton() {
    return FlatButton(
      child: Text(
        "Do not have account, Please Register",
        textScaleFactor: 1,
      ),
      onPressed: () {
        debugPrint("Register Clicked from Signin Page");
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          passwordController.text = "";
          return Register(
            userType: UserType.user,
          );
        }));
      },
    );
  }
}
