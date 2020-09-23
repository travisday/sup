import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sup/api/auth.dart';
import 'package:sup/model/user.dart';

class UserService {
  final Firestore _db;

  UserService(this._db);

  Stream<List<User>> friendsList() {
    User me = auth.getCurrentUser();

    return getUsers().snapshots().map((list) => list.documents
        .where((element) => element.documentID != me.uid)
        .map((doc) => User.fromFirestore(doc))
        .toList());
  }

  Query getUsers() {
    return this._db.collection('users').orderBy('score').limit(20);
  }

  addToScore(User user) async {
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .setData({'score': (user.score ?? 0) + 1}, merge: true);
  }
}

final UserService userService = UserService(Firestore.instance);