import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/book/book-ticket.dart';
import 'package:flutter_firebase_demo/bus/insert-bus.dart';
import 'package:flutter_firebase_demo/general/back.dart';
import 'package:flutter_firebase_demo/route/insert-route.dart';
import 'package:flutter_firebase_demo/user/UserType.dart';
import 'package:flutter_firebase_demo/user/signin.dart';
import 'package:flutter_firebase_demo/user/user-information.dart';

class NormalMenu extends StatelessWidget {
  final String userType;

  NormalMenu({this.userType});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(userType: this.userType),
    );
  }
}

class MyHomePage extends StatelessWidget {
  String appTitle = 'Welcome';
  final String userType;
  Widget widget;

  MyHomePage({Key key, this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.userType == UserType.admin) {
      this.appTitle = "User Information";
      widget = UserInformation();
    } else {
      this.appTitle = "Pay Fair";
      widget = BookTicket();
    }

    return WillPopScope(
        onWillPop: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignIn()),
            (route) => false,
          );
        },
        child: Scaffold(
          appBar: AppBar(title: Text(appTitle), actions: [
            FlatButton(
              child: Text("Log Out"),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                  (route) => false,
                );
              },
            ),
          ]),
          body: Center(child: widget),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Profile Picture'),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: Text('Add Bus'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      debugPrint("Bus Operation Navigation.");
                      return InsertBus();
                    }));
                  },
                ),
                ListTile(
                  title: Text('Add Route'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      debugPrint("Route Operation Navigation.");
                      return InsertRoute();
                    }));
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
