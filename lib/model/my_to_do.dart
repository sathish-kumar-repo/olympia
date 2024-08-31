import 'package:cloud_firestore/cloud_firestore.dart';

class MyToDo {
  final String id;
  final String title;
  final DateTime dateTime;
  final bool isFinish;

  MyToDo({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.isFinish,
  });

  factory MyToDo.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map data = doc.data()!;

    // doc.id
    return MyToDo(
      id: data['id'],
      title: data['title'],
      dateTime: data['timestamp'].toDate(),
      isFinish: data['isFinish'],
    );
  }
}
