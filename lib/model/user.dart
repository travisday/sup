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
    // username: data['username'],
    // age: data['age'],
    // photoUrl: data['photoUrl']);
  }
  // factory User.fromMap(Map data) {
  //   return User(
  //       uid: data['uid'],
  //       name: data['name'],
  //       username: data['username'],
  //       age: data['age'],
  //       photoUrl: data['photoUrl']);
  // }

  get entriesPath => 'users/$uid/entries/';
  @override
  String toString() {
    return '{ name: $name, email: $email, uid: $uid }';
  }
}
