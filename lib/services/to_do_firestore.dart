import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:olympia/model/my_to_do.dart';
import 'package:uuid/uuid.dart';

class ToDoFirestoreService {
  // Collection Reference
  final CollectionReference<Map<String, dynamic>> _toDoCollection =
      FirebaseFirestore.instance.collection('toDo');

  // ToDo STREAM
  Stream<List<MyToDo>> getToDoStream(bool isFinish) {
    return _toDoCollection
        .orderBy('timestamp', descending: true)
        .where('isFinish', isEqualTo: isFinish)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (doc) => MyToDo.fromFirestore(doc),
            )
            .toList());
  }

  Future<void> addToDo({
    required String title,
  }) async {
    String uuid = const Uuid().v4();
    Timestamp timestamp = Timestamp.now();
    await _toDoCollection.doc(uuid).set({
      'id': uuid,
      'title': title,
      'timestamp': timestamp,
      'isFinish': false,
    });
  }

  Future<void> editToDo({
    required String id,
    required String title,
  }) async {
    Timestamp timestamp = Timestamp.now();
    await _toDoCollection.doc(id).update({
      'title': title,
      'timestamp': timestamp,
    });
  }

  Future<void> completeToDo({
    required String id,
    required bool isFinish,
  }) async {
    await _toDoCollection.doc(id).update({
      'isFinish': isFinish,
    });
  }

  Future<void> deleteToDo({
    required String id,
  }) async {
    await _toDoCollection.doc(id).delete();
  }
}
