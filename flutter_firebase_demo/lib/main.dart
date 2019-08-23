import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/user/signin.dart';

void main() => runApp(MaterialApp(
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => SignIn(),
      },
    ));
