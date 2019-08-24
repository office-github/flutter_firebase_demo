import 'package:cloud_firestore/cloud_firestore.dart';

class Bus {
  String number; //Unique
  String name;
  String owner; //Company or owner person
  double discount; //Percentage
  double bonus; //Percentage
  double totalFair; //double value
  final DocumentReference reference;

  Bus.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['number'] != null),
        assert(map['owner'] != null),
        assert(map['name'] != null),
        assert(map['discount'] != null),
        assert(map['bonus'] != null),
        assert(map['totalFair'] != null),
        number = map['number'],
        owner = map['owner'],
        name = map['name'],
        discount = double.parse(map['discount'].toString()),
        bonus = double.parse(map['bonus'].toString()),
        totalFair = double.parse(map['totalFair'].toString());

  Bus.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Bus Number: $number, total Fair: $totalFair";
}
