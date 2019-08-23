import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/bus/bus.dart';
import 'package:flutter_firebase_demo/general/back.dart';

class BusInformation extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<BusInformation> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          back(context);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Bus Information"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                back(context);
              },
            ),
          ),
          body: _buildBody(context),
          //body: Text("Bus Information"),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Bus').snapshots(),
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
      final record = Bus.fromSnapshot(data);

      return Padding(
        key: ValueKey(record.number),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(record.number),
            trailing: Text(record.owner),
            subtitle: Text(
                "Routes: ${record.routes}\nTotal Fair: ${record.totalFair}\nDiscount: ${record.discount} %\n Bonus: ${record.bonus}"),
            // onTap: () => Firestore.instance.runTransaction((transaction) async {
            //       final freshSnapshot = await transaction.get(record.reference);
            //       final fresh = Record.fromSnapshot(freshSnapshot);

            //       await transaction
            //           .update(record.reference, {'votes': fresh.votes + 1});
            //     }),
          ),
        ),
      );
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
