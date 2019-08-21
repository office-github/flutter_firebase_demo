import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final String userType;

  Register({this.userType});

  @override
  State<StatefulWidget> createState() => _RegisterState(this.userType);
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController idController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repassWordController = TextEditingController();
  final String userType;

  _RegisterState(this.userType);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          back(context);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Registration"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  back(context);
                },
              ),
            ),
            body: getForm(this.userType)));
  }

  Widget getForm(userType) {
    return Form(
      key: _formKey,
      autovalidate: true,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: getRegisterWidget(userType),
        ),
      ),
    );
  }

//Add record to the firebase database.
  void register() {
    int id = int.parse(idController.text.trim());
    String userType =
        userTypeController.text.isEmpty || userTypeController.text == null
            ? "user"
            : userTypeController.text;
    String fullName = fullNameController.text.trim();
    String email = emailController.text.trim();
    int phoneNo = int.parse(phoneNoController.text.trim());
    String password = passwordController.text.trim();

    debugPrint("Name: $id, UserType: $userType");

//Get the firebase database collection refrence of the baby collection.
    CollectionReference reference = Firestore.instance.collection('User');
    Map<String, dynamic> map = new Map();
    map.addAll({
      "id": id,
      "userType": userType,
      "fullName": fullName,
      "email": email,
      "phoneNo": phoneNo,
      "password": password
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

  getUserTypeDropDown() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 14.0),
      controller: userTypeController,
      validator: (String value) {
        if (value.isEmpty) {
          return "User Type Required";
        }
      },
      decoration: InputDecoration(
          labelText: "User Type",
          hintText: "Please Enter User Type",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getFulNameTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14.0),
      controller: fullNameController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Full Name Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Full Name",
          hintText: "Please Enter Full Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getEmailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 14.0),
      controller: emailController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Email Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Email",
          hintText: "Please Enter Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getPhoneNoTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      maxLength: 10,
      maxLengthEnforced: true,
      style: TextStyle(fontSize: 14.0),
      controller: phoneNoController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Phone No. Required";
        }
      },
      decoration: InputDecoration(
          labelText: "Phone No.",
          hintText: "Please Enter Phone No.",
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
      controller: repassWordController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Re-Password Required";
        } else if (value != passwordController.text) {
          return 'Password did not match';
        }
      },
      decoration: InputDecoration(
          labelText: "Re-Password",
          hintText: "Please Enter Re-Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }

  getRegisterButton() {
    return Padding(
      padding:
          EdgeInsets.only(top: 10.0, bottom: 10.0, left: 50.0, right: 50.0),
      child: RaisedButton(
        child: Text(
          "Register",
          textScaleFactor: 1.5,
        ),
        onPressed: () {
          setState(() {
            if (_formKey.currentState.validate()) {
              debugPrint("Register Clicked");
              register();
            }
          });
        },
      ),
    );
  }

  List<Widget> getRegisterWidget(userType) {
    if (userType == "admin") {
      return [
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: getIdTextField()),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: getUserTypeDropDown()),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: getFulNameTextField()),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: getEmailTextField()),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: getPhoneNoTextField()),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: getPasswordTextField()),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: getRePasswordTextField()),
        getRegisterButton()
      ];
    }

    return [
      Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: getIdTextField()),
      Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: getFulNameTextField()),
      Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: getEmailTextField()),
      Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: getPhoneNoTextField()),
      Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: getPasswordTextField()),
      Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: getRePasswordTextField()),
      getRegisterButton()
    ];
  }
}
