import 'package:cloud_firestore/cloud_firestore.dart';

class BusRoute {
  int id;
  String place;
  final DocumentReference reference;

  BusRoute.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['place'] != null),
        id = map['id'],
        place = map['place'];

  BusRoute.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$id:$place>";
}
