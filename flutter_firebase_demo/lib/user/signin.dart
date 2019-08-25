import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_demo/dialog/dialog.dart';
import 'package:flutter_firebase_demo/general/back.dart';
import 'package:flutter_firebase_demo/general/environment.dart';
import 'package:flutter_firebase_demo/general/message_type.dart';
import 'package:flutter_firebase_demo/menu/gridview_menu.dart';
import 'package:flutter_firebase_demo/menu/normal_menu.dart';
import 'package:flutter_firebase_demo/user/user_type.dart';
import 'package:flutter_firebase_demo/user/current_user.dart';
import 'package:flutter_firebase_demo/user/password_operation.dart';
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
  String selectedEnvironment = Environment.demo;

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
            getRegisterButton(),
            getEnvironmentDropDown()
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
    if (this.selectedEnvironment == Environment.production) {
      CollectionReference reference = Firestore.instance.collection('User');
      reference
          .where("email", isEqualTo: userName.toLowerCase())
          .where("password", isEqualTo: password)
          .getDocuments()
          .then((snapshot) {
        if (snapshot.documents.length > 0) {
          CurrentUser.signIn(snapshot.documents[0]);
          redirectToPage();
        } else {
          reference
              .where("phoneNo", isEqualTo: int.parse(userName))
              .where("password", isEqualTo: password)
              .getDocuments()
              .then((snapshot) {
            if (snapshot.documents.length > 0) {
              CurrentUser.signIn(snapshot.documents[0]);
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
        print(e);
        print(s);
        back(context);
        showMessageDialog(
            context: context,
            title: "Sign In Error",
            message: "Error occured. Please try again later.",
            type: MessageType.error);
      });
    } else if (this.selectedEnvironment == Environment.demo) {
      back(context);
      CurrentUser.signInForDemo(UserType.admin);
      redirectToPage();
    } else {}
  }

  redirectToPage() {
    passwordController.text = "";
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      debugPrint("Signed In Successfully.");
      return NormalMenu();
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
          return Register();
        }));
      },
    );
  }

  getEnvironmentDropDown() {
    final items = [
      Environment.production,
      Environment.staging,
      Environment.demo
    ];

    return Container(
        width: 100.0,
        child: Center(
          child: DropdownButton<String>(
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (envrionment) {
              setState(() {
                this.selectedEnvironment = envrionment;
              });
            },
            value: this.selectedEnvironment,
          ),
        ));
  }
}
