import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:olympia/model/my_save.dart';
import 'package:uuid/uuid.dart';

class SaveFirestoreService {
  // Collection Reference
  final CollectionReference<Map<String, dynamic>> _saveCollection =
      FirebaseFirestore.instance.collection('save');

  // SAVE STREAM
  Stream<List<MySave>> getSaveStream() {
    return _saveCollection
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (doc) => MySave.fromFirestore(doc),
            )
            .toList());
  }

  Future<void> addSave({
    required String title,
    required String save,
  }) async {
    String uuid = const Uuid().v4();
    Timestamp timestamp = Timestamp.now();

    await _saveCollection.doc(uuid).set({
      'id': uuid,
      'title': title,
      'dateTime': timestamp,
      'save': save,
    });
  }

  Future<void> renameTitle({
    required String id,
    required String title,
  }) async {
    await _saveCollection.doc(id).update({
      'id': id,
      'title': title,
    });
  }

  Future<void> editSave({
    required String id,
    required String save,
  }) async {
    Timestamp timestamp = Timestamp.now();
    await _saveCollection.doc(id).update({
      'dateTime': timestamp,
      'save': save,
    });
  }

  Future<void> deleteSave({
    required String id,
  }) async {
    await _saveCollection.doc(id).delete();
  }
}
