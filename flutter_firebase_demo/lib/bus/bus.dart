import 'package:cloud_firestore/cloud_firestore.dart';

class Bus {
  String number; //Unique
  String owner; //Company or owner person
  double discount; //Percentage
  double bonus; //Percentage
  double totalFair; //double value
  String routes; //Comma separated values of strings
  final DocumentReference reference;

  Bus.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['number'] != null),
        assert(map['owner'] != null),
        assert(map['discount'] != null),
        assert(map['bonus'] != null),
        assert(map['totalFair'] != null),
        assert(map['routes'] != null),
        number = map['number'],
        owner = map['owner'],
        discount = map['discount'],
        bonus = map['bonus'],
        totalFair = map['totalFair'],
        routes = map['routes'];

  Bus.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Bus Number: $number, total Fair: $totalFair";
}
