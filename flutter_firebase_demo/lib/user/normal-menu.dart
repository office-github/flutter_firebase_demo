import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/book/book-ticket.dart';
import 'package:flutter_firebase_demo/bus/insert-bus.dart';
import 'package:flutter_firebase_demo/route/insert-route.dart';
import 'package:flutter_firebase_demo/user/UserType.dart';
import 'package:flutter_firebase_demo/user/register.dart';
import 'package:flutter_firebase_demo/user/user-information.dart';

class NormalMenu extends StatefulWidget {
  final String userType;

  NormalMenu({this.userType});

  @override
  State<StatefulWidget> createState() =>
      _NormalMenuState(userType: this.userType);
}

class _NormalMenuState extends State<NormalMenu> {
  String appTitle = 'Welcome';
  final String userType;
  Widget viewBasedOnUser;

  _NormalMenuState({this.userType});

  @override
  void initState() {
    if (this.userType == UserType.admin) {
      this.appTitle = "User Information";
      viewBasedOnUser = UserInformation();
    } else {
      this.appTitle = "Pay Fair";
      viewBasedOnUser = BookTicket();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appTitle), actions: [
        FlatButton(
          child: Text("Log Out"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ]),
      body: Center(child: viewBasedOnUser),
      drawer: Drawer(
        child: ListView(
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  debugPrint("Insert Bus Navigation.");
                  return InsertBus();
                }));
              },
            ),
            ListTile(
              title: Text('Add Route'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  debugPrint("Insert Route Navigation.");
                  return InsertRoute();
                }));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("floating button clicked!");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Register(
              userType: UserType.admin,
            );
          }));
        },
        child: Icon(Icons.add),
        tooltip: "User Registration",
      ),
    );
  }
}
