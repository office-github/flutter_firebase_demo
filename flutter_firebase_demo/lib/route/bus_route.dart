import 'package:cloud_firestore/cloud_firestore.dart';

class BusRoute {
  String place;
  final DocumentReference reference;

  BusRoute.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['place'] != null),
        place = map['place'];

  BusRoute.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Route Place: $place";
}
