import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String email;
  int score;
  List<String> favUsers;

  User({this.uid, this.name, this.email, this.score = -1, this.favUsers});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return User(
        uid: doc.documentID,
        name: data['name'],
        email: data['email'],
        score: data['score'] ?? -1,
        favUsers: List.from(data['favUsers']));
  }

  @override
  String toString() {
    return '{ name: $name, email: $email, score: $score uid: $uid, favUsers: $favUsers }';
  }
}

class Friend extends User {
  factory Friend.fromFirestore(DocumentSnapshot doc) {
    return User.fromFirestore(doc);
  }
}
