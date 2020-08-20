import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sup/api/auth.dart';
import 'package:sup/model/log.dart';

class LogService {
  final Firestore _db;

  LogService(this._db);

  Stream<List<Log>> asList() {
    return getUserLogs()
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((list) => list.documents.map((doc) => Log.fromSnap(doc)).toList());
  }

  Future<void> update(Log e) async {
    var map = e.toMap();
    map['updated_at'] = Timestamp.now();
    return getUserLogs().document(e.uid).updateData(map);
  }

  void delete(Log e) async {
    return getUserLogs().document(e.uid).delete();
  }

  CollectionReference getUserLogs() {
    return this
        ._db
        .collection('users')
        .document(auth.getCurrentUser().uid)
        .collection('logs');
  }

  Future<DocumentReference> newLog(String text) {
    var log = Log(text: text);
    return getUserLogs().add(log.toMap());
  }

  Future<DocumentReference> newTodo(String text,
      {TodoStatus status, DateTime dueDate}) {
    var todo = Log(
        text: text,
        type: "todo",
        status: status ?? TodoStatus.incomplete,
        dueDate: dueDate);
    return getUserLogs().add(todo.toMap());
  }
}

final LogService logService = LogService(Firestore.instance);
