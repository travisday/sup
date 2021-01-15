import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String email;
  double score;
  int sendCount;
  int maxSup;
  int streak;
  DateTime lastOnline;
  List<String> favUsers;

  User(
      {this.uid,
      this.name,
      this.email,
      this.score = 0,
      this.sendCount,
      this.maxSup,
      this.lastOnline,
      this.streak = 0,
      this.favUsers});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return User(
        uid: doc.documentID,
        name: data['name'],
        email: data['email'],
        score: data['score'] ?? 0,
        sendCount: data['sendCount'] ?? 5,
        maxSup: data['maxSup'] ?? 5,
        lastOnline:
            (data['lastOnline'] as Timestamp).toDate() ?? DateTime.now(),
        streak: data['streak'] ?? 0,
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
