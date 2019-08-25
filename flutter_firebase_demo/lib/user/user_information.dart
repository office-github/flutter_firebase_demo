import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/user/user.dart';

class UserInformation extends StatelessWidget {
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
      //body: _buildBody(context),
      body: Text("User Information"),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('User').snapshots(),
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
            title: Text(record.fullName),
            trailing: Text(record.userType),
            subtitle:
                Text("Email: ${record.email}\nPhone No.: ${record.phoneNo}\nAmount: Rs.${record.amount}\nBonus: ${record.bonus}"),
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
