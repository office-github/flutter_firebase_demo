import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/book/book.dart';
import 'package:flutter_firebase_demo/general/back.dart';
import 'package:flutter_firebase_demo/user/current_user.dart';
import 'package:flutter_firebase_demo/user/user_type.dart';

class TicketInformation extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<TicketInformation> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          back(context);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Ticket Information"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                back(context);
              },
            ),
          ),
          body: _buildBody(context),
          //body: Text("Ticket Information"),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

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
      final record = Book.fromSnapshot(data);

      return Padding(
        key: ValueKey(record.bookedDate),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
              title: Text("User ID: ${record.userId}, Bus ID: ${record.busId}"),
              trailing: Text("Rs. ${record.totalFair}"),
              subtitle: Text(getDescription(record))),
          // onTap: () => Firestore.instance.runTransaction((transaction) async {
          //       final freshSnapshot = await transaction.get(record.reference);
          //       final fresh = Record.fromSnapshot(freshSnapshot);

          //       await transaction
          //           .update(record.reference, {'votes': fresh.votes + 1});
          //     }),
        ),
      );
    } catch (e) {
      debugPrint(e);
    }
  }

  Stream<QuerySnapshot> getStream() {
    if (CurrentUser.userType == UserType.admin) {
      return Firestore.instance.collection('Book').snapshots();
    } else {
      return Firestore.instance
          .collection('Book')
          .where("userId", isEqualTo: CurrentUser.email)
          .snapshots();
    }
  }

  String getDescription(Book record) {
    return "Source: ${record.source}\nDestination: ${record.destination}\nBooked Date: ${record.bookedDate.toString().substring(0, 16)}\nJourney Date: ${record.journeyDate.toString().substring(0, 16)}";
  }
}
