import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_demo/user/user_type.dart';

class CurrentUser {
  static int id;
  static String email;
  static int phoneNo;
  static String userType;
  static double bonus;
  static double amount;
  static bool isAuthenticated;

//Just for demo app
  static signInForDemo(String userType) {
    id = 1;
    email = "a@a.com";
    phoneNo = 9876543210;
    userType = userType;
    bonus = 1.0;
    amount = 0.0;
    isAuthenticated = true;
  }

  static signIn(DocumentSnapshot document) {
    id = document.data["id"];
    userType = document.data[UserType.text];
    email = document.data["email"];
    phoneNo = document.data["phoneNo"];
    bonus = double.parse(document.data["bonus"].toString());
    amount = double.parse(document.data["amount"].toString());
    isAuthenticated = true;
  }

  static logOut() {
    id = 0;
    email = null;
    phoneNo = 0;
    userType = null;
    bonus = 0.0;
    amount = 0.0;
    isAuthenticated = false;
  }
}
