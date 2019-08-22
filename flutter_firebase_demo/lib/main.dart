import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/user/signin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignIn());
  }
}
