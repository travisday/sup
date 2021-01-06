import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sup/api/auth.dart';
import 'package:sup/model/user.dart';
import 'package:sup/api/score.dart';

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

  Stream<User> me() {
    return this
        ._db
        .collection("users")
        .document(auth.getCurrentUser().uid)
        .snapshots()
        .map((doc) => User.fromFirestore(doc));
  }

  addToScore(User user) async {
    Firestore.instance.collection('users').document(user.uid).setData(
        {'score': (user.score ?? 0) + scoreService.calculateScore()},
        merge: true);
  }

  addFavUser(User user, User fav) async {
    Firestore.instance.collection('users').document(user.uid).updateData({
      "favUsers": FieldValue.arrayUnion([fav.uid])
    });
  }

  removeFavUser(User user, User fav) async {
    Firestore.instance.collection('users').document(user.uid).updateData({
      "favUsers": FieldValue.arrayRemove([fav.uid])
    });
  }

  sendSup(User friend) async {}
  setPushToken(String token) async {
    this
        ._db
        .collection('users')
        .document((await FirebaseAuth.instance.currentUser()).uid)
        .updateData({'pushToken': token});
  }
}

final UserService userService = UserService(Firestore.instance);
