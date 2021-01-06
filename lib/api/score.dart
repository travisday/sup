import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sup/api/auth.dart';
import 'package:sup/model/user.dart';
import 'package:sup/api/user_service.dart';

class ScoreService {
  var number_friends = userService.friendsList().length;

  int calculateScore() {
    return 1;
  }
}

final ScoreService scoreService = ScoreService();
