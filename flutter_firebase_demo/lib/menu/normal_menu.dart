import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/book/book_ticket.dart';
import 'package:flutter_firebase_demo/book/ticket_information.dart';
import 'package:flutter_firebase_demo/bus/bus_information.dart';
import 'package:flutter_firebase_demo/bus/insert_bus.dart';
import 'package:flutter_firebase_demo/dialog/dialog.dart';
import 'package:flutter_firebase_demo/general/message_type.dart';
import 'package:flutter_firebase_demo/qr/manual_qr_generator.dart';
import 'package:flutter_firebase_demo/qr/qr_reader.dart';
import 'package:flutter_firebase_demo/route/insert_route.dart';
import 'package:flutter_firebase_demo/route/route_information.dart';
import 'package:flutter_firebase_demo/user/current_user.dart';
import 'package:flutter_firebase_demo/user/signin.dart';
import 'package:flutter_firebase_demo/user/user_type.dart';
import 'package:flutter_firebase_demo/user/register.dart';
import 'package:flutter_firebase_demo/user/user_information.dart';

class NormalMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NormalMenuState();
}

class _NormalMenuState extends State<NormalMenu> {
  String appTitle = 'Welcome';
  Widget viewBasedOnUser;

  @override
  void initState() {
    if (CurrentUser.userType == UserType.admin) {
      this.appTitle = "User Information";
      viewBasedOnUser = UserInformation();
    } else {
      this.appTitle = "Pay Fair";
      viewBasedOnUser = QRReader();
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
            if (CurrentUser.userType == UserType.admin) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                debugPrint("Sign In Navigation.");
                return SignIn();
              }));
            }
          },
        ),
      ]),
      body: Center(child: viewBasedOnUser),
      drawer: Drawer(child: getViewBasedOnUserType()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("floating button clicked!");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Register();
          }));
        },
        child: Icon(Icons.add),
        tooltip: "User Registration",
      ),
    );
  }

  ListView getViewBasedOnUserType() {
    return ListView(padding: EdgeInsets.zero, children: getViews());
  }

  List<Widget> getViews() {
    if (CurrentUser.isAuthenticated) {
      if (CurrentUser.userType == UserType.admin) {
        return <Widget>[
          DrawerHeader(
            child: Row(
              children: <Widget>[
                Text("Email: " + CurrentUser.email + "\nPhone No.: " + CurrentUser.phoneNo.toString() + "\n\nAmount Rs." +
                    CurrentUser.amount.toString() +
                    "\nBonus Rs." +
                    CurrentUser.bonus.toString()),
              ],
            ),
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
          Divider(
            color: Theme.of(context).primaryColor,
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
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          ListTile(
            title: Text('Show Bus Infomation'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                debugPrint("Show Bus Information Navigation.");
                return BusInformation();
              }));
            },
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          ListTile(
            title: Text('Show Route Information'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                debugPrint("Show Route Information Navigation.");
                return RouteInformation();
              }));
            },
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          ListTile(
            title: Text('Show Ticket Information'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                debugPrint("Show Ticekt Information Navigation.");
                return TicketInformation();
              }));
            },
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          ListTile(
            title: Text('Manual QR Generator'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                debugPrint("Manual QR GeneratorNavigation.");
                return ManualQRGeneratorState();
              }));
            },
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          )
        ];
      }

      return <Widget>[
        DrawerHeader(
          child: Row(
            children: <Widget>[
              Text("Email: " + CurrentUser.email + "\nPhone No.: " + CurrentUser.phoneNo.toString() + "\n\nAmount Rs. : " +
                  CurrentUser.amount.toString() +
                  "\nBonus Rs. : " +
                  CurrentUser.bonus.toString()),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Show Ticket Information'),
          onTap: () {
            showCircularProgressBar(context);
            CollectionReference reference =
                Firestore.instance.collection('Book');
            reference
                .where("userId", isEqualTo: CurrentUser.email.toLowerCase())
                .getDocuments()
                .then((snapshot) {
              Navigator.pop(context);
              if (snapshot.documents.length > 0) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  debugPrint("Show Ticekt Information Navigation.");
                  return TicketInformation();
                }));
              } else {
                showMessageDialog(
                    context: context,
                    title: "Ticket Information",
                    message: "You Have Not Booked Any Ticket",
                    type: MessageType.warning);
              }
            });
          },
        ),
        Divider(
          color: Theme.of(context).primaryColor,
        ),
      ];
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      //return GridViewMenu();
    }
  }
}
