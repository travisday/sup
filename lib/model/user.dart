import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String email;

  User({this.uid, this.name, this.email});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return User(
      uid: doc.documentID,
      name: data['name'],
      email: data['email'],
    );
  }

  @override
  String toString() {
    return '{ name: $name, email: $email, uid: $uid }';
  }
}
