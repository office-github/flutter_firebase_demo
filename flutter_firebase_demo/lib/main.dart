import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/baby/add_baby.dart';
import 'package:flutter_firebase_demo/book/book.dart';
import 'package:flutter_firebase_demo/bus/bus.dart';
import 'package:flutter_firebase_demo/route/route.dart';
import 'package:flutter_firebase_demo/user/signin.dart';
import 'package:flutter_firebase_demo/user/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Information')),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("Add button clicked!");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SignIn();
          }));
        },
        child: Icon(Icons.add),
        tooltip: "Add More Item",
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('User').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    try {
      final record = User.fromSnapshot(data);

      return Padding(
        key: ValueKey(record.id),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(record.email),
            trailing: Text(record.password),
            // onTap: () => Firestore.instance.runTransaction((transaction) async {
            //       final freshSnapshot = await transaction.get(record.reference);
            //       final fresh = Record.fromSnapshot(freshSnapshot);

            //       await transaction
            //           .update(record.reference, {'votes': fresh.votes + 1});
            //     }),
          ),
        ),
      );
    } catch (e) {
      debugPrint(e);
    }
  }
}

class Record {
  final String name;
  final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        name = map['name'],
        votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes>";
}

class User {
  final int id;
  final String userType;
  final String fullName;
  final String email;
  final int phoneNo;
  final String password;
  final DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['userType'] != null),
        assert(map['fullName'] != null),
        assert(map['email'] != null),
        assert(map['phoneNo'] != null),
        assert(map['password'] != null),
        id = map['id'],
        userType = map['userType'],
        fullName = map['fullName'],
        email = map['email'],
        phoneNo = map['phoneNo'],
        password = map['password'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "User<$id:$fullName>";
}

class Bus {
  int id;
  String number; //Unique
  String owner; //Company or owner person
  String routes; //Comma separated values of strings
  final DocumentReference reference;

  Bus.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['number'] != null),
        assert(map['owner'] != null),
        assert(map['routes'] != null),
        id = map['id'],
        number = map['number'],
        owner = map['owner'],
        routes = map['routes'];

  Bus.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "User<$id:$number>";
}

class Route {
  int id;
  String place;
  final DocumentReference reference;

  Route.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['place'] != null),
        id = map['id'],
        place = map['place'];

  Route.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$id:$place>";
}

class Book {
  int id;
  int userId;
  int busId;
  String source;
  String destination;
  double fair;
  double discount; //Percentage
  double totalFair; //After discount
  final DocumentReference reference;

  Book.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['userId'] != null),
        assert(map['busId'] != null),
        assert(map['source'] != null),
        assert(map['destination'] != null),
        assert(map['fair'] != null),
        assert(map['discount'] != null),
        assert(map['totalFair'] != null),
        id = map['id'],
        userId = map['userId'],
        busId = map['busId'],
        source = map['source'],
        destination = map['destination'],
        fair = map['fair'],
        discount = map['discount'],
        totalFair = map['totalFair'];

  Book.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "User<$id:$userId:$busId>";
}
