import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sup/model/user.dart';
import 'package:rxdart/rxdart.dart';

abstract class AuthState {
  get user;
}

class LoggedIn extends AuthState {
  User user;

  LoggedIn(this.user);
}

class LoggedOut extends AuthState {
  get user => null;
}

class Loading extends AuthState {
  get user => null;
}

class AuthService {
  final FirebaseAuth _firebaseAuth;
  BehaviorSubject<AuthState> status;

  AuthService(this._firebaseAuth) {
    status = BehaviorSubject<AuthState>.seeded(Loading());

    listen();
  }
  listen() async {
    await for (FirebaseUser u in _firebaseAuth.onAuthStateChanged) {
      if (u != null) {
        DocumentReference ref =
            Firestore.instance.collection('users').document(u.uid);
        DocumentSnapshot snap = await ref.get();
        if (snap == null || !snap.exists) {
          await ref.setData({
            if (u.displayName != null) 'name': u.displayName,
            'email': u.email,
            'profilePic': "",
            'maxSup': 20,
            'score': 0,
            'sendCount': 20,
            'streak': 0,
            'favUsers': [],
            'lastOnline': DateTime.now()
          });
          snap = await ref.get();
        }
        User user = User.fromFirestore(snap);
        print(user);
        status.add(LoggedIn(user));
      } else {
        status.add(LoggedOut());
      }
    }
  }

  Future<AuthResult> signIn(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResult> signUp(
      {String email, String password, String displayName}) async {
    AuthResult res = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    var u = res.user;
    DocumentReference ref =
        Firestore.instance.collection('users').document(u.uid);
    DocumentSnapshot snap = await ref.get();
    await ref.setData({
      'name': displayName,
      'profilePic': "",
      'maxSup': 20,
      'score': 0,
      'sendCount': 20,
      'streak': 0,
      'favUsers': [],
      'lastOnline': DateTime.now()
    }, merge: true);
    snap = await ref.get();

    User user = User.fromFirestore(snap);
    status.add(LoggedIn(user));

    print(user);
    return res;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  bool isSignedIn() {
    return this.status.value is LoggedIn;
  }

  User getCurrentUser() => this.status.value.user;
}

final AuthService auth = AuthService(FirebaseAuth.instance);
