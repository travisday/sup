import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

enum TodoStatus {
  complete,
  incomplete,
  discarded,
}
Map<String, TodoStatus> statuses = {
  'complete': TodoStatus.complete,
  'incomplete': TodoStatus.incomplete,
  'discarded': TodoStatus.discarded,
};
Map<TodoStatus, String> statusStrs = {
  TodoStatus.complete: 'complete',
  TodoStatus.incomplete: 'incomplete',
  TodoStatus.discarded: 'discarded',
};

TodoStatus stringToStatus(String str) {
  return statuses[str] ?? TodoStatus.incomplete;
}

class Log {
  String uid;
  String type;
  String _text = '';

  set text(String text) => this._text = text ?? '';
  String get text => _text;

  DateTime createdAt;
  DateTime updatedAt;

  DateTime dueDate;
  DateTime completedDate;
  TodoStatus status;

  DocumentSnapshot snap;
  bool existsInDb = false;
  bool deleted = false;

  Log({
    this.uid,
    type,
    text = "",
    createdAt,
    updatedAt,
    this.dueDate,
    this.snap,
    this.status,
    existsInDb,
  }) {
    this.existsInDb = existsInDb ?? false;
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
    this.type = type ?? 'text';
    this.text = text;
  }

  factory Log.fromSnap(DocumentSnapshot snap) {
    var data = snap.data;
    DateTime createdAt = data['created_at'] != null
        ? (data['created_at'] as Timestamp).toDate()
        : DateTime.now();
    DateTime updatedAt = data['updated_at'] != null
        ? (data['updated_at'] as Timestamp).toDate()
        : DateTime.now();
    DateTime dueDate = data['due_date'] != null
        ? (data['due_date'] as Timestamp).toDate()
        : null;

    return Log(
      existsInDb: true,
      uid: snap.documentID,
      type: data['type'],
      text: data['text'],
      createdAt: createdAt,
      updatedAt: updatedAt,
      dueDate: dueDate,
      status: stringToStatus(snap.data['status']),
      snap: snap,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map['created_at'] = Timestamp.fromDate(createdAt);
    map['due_date'] = dueDate == null ? null : Timestamp.fromDate(dueDate);
    map['text'] = text;
    map['type'] = type;
    map['deleted'] = deleted;
    map['status'] = statusStrs[status];
    return map;
  }

  String get dateString =>
      DateFormat("EEEE, LLLL d").format(createdAt).toLowerCase();

  String get timeString => DateFormat.jms().format(createdAt);

  DateTime getCalendarDate() => DateTime(
        createdAt.year,
        createdAt.month,
        createdAt.day,
      );

  @override
  String toString() => 'Entry for ${this.dateString}';
}
