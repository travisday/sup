import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sup/model/user.dart';

class UserService {
  final Firestore _db;

  UserService(this._db);

  Stream<List<User>> asList() {
    return getUsers().snapshots().map((list) =>
        list.documents.map((doc) => User.fromFirestore(doc)).toList());
  }

  CollectionReference getUsers() {
    return this._db.collection('users');
  }

  addToScore(User user) async {
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .setData({'score': (user.score ?? 0) + 1}, merge: true);
  }
}

final UserService logService = UserService(Firestore.instance);
