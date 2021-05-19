import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sup/api/auth.dart';
import 'package:sup/model/user.dart';
import 'package:path/path.dart';
import 'dart:io';

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
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .setData({'score': (user.score ?? 0) + 1}, merge: true);
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

  updateLastOnline(User user) async {
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .updateData({"lastOnline": Timestamp.fromDate(DateTime.now())});
  }

  updateStreak(User user) async {
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .setData({"streak": (user.streak ?? 0) + 1}, merge: true);
  }

  sendSup(User friend) async {}
  setPushToken(String token) async {
    this
        ._db
        .collection('users')
        .document((await FirebaseAuth.instance.currentUser()).uid)
        .updateData({'pushToken': token});
  }

  addProfilePic(String fileURL) async {
    User me = auth.getCurrentUser();
    var oldUrl = me.profilePic;
    Firestore.instance
        .collection('users')
        .document(me.uid)
        .setData({"profilePic": fileURL}, merge: true);

    print("new: $fileURL");
    print("old: $oldUrl");

    if (oldUrl.isNotEmpty) {
      FirebaseStorage.instance.getReferenceFromUrl(oldUrl).then((img) {
        img.delete().then((res) {
          print("Deleted!");
        });
        //print(res.getName());
      });
    }
  }

  Future uploadFile(File _image) async {
    var urlName = basename(_image.path);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("profile_pic/$urlName");
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      addProfilePic(fileURL);
    });
  }
}

final UserService userService = UserService(Firestore.instance);
