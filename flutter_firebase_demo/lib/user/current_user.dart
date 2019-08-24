import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_demo/user/user_type.dart';

class CurrentUser {
  static int id;
  static String email;
  static int phoneNo;
  static String userType;
  static bool isAuthenticated;

//Just for demo app
  static signInForDemo(String userType) {
    id = 1;
    email = "a@a.com";
    phoneNo = 9876543210;
    userType = userType;
    isAuthenticated = true;
  }

  static signIn(DocumentSnapshot document) {
    id = document.data["id"];
    userType = document.data[UserType.text];
    email = document.data["email"];
    phoneNo = document.data["phoneNo"];
    isAuthenticated = true;
  }

  static logOut() {
    id = 0;
    email = null;
    phoneNo = 0;
    userType = null;
    isAuthenticated = false;
  }
}
