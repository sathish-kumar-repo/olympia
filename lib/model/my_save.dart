import 'package:cloud_firestore/cloud_firestore.dart';

class MySave {
  final String id;
  final String title;
  final DateTime dateTime;
  final String saveNote;

  MySave({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.saveNote,
  });

  factory MySave.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map data = doc.data()!;
    // doc.id
    return MySave(
      id: data['id'],
      title: data['title'],
      dateTime: data['dateTime'].toDate(),
      saveNote: data['save'],
    );
  }
}
