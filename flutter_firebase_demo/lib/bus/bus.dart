import 'package:cloud_firestore/cloud_firestore.dart';

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
