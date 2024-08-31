import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class TrainingFirestoreServices {
  // Collection Reference
  final CollectionReference<Map<String, dynamic>> _dreamCollection =
      FirebaseFirestore.instance.collection('dream');

  // // TRAINING STREAM
  // Stream<QuerySnapshot<Map<String, dynamic>>> getTrainingStream() {
  //   return _dreamCollection.snapshots();
  // }
  // TRAINING STREAM
  Stream<DocumentSnapshot<Map<String, dynamic>>> getTrainingStream(String doc) {
    return _dreamCollection.doc(doc).snapshots();
  }

  // ADD
  Future<void> addTrainingSection({
    required String doc,
    required String title,
    required int order,
    required List<String> workout,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _getDocSnap(doc);
    if (!documentSnapshot.exists) return;
    // My Training Map
    Map<String, dynamic> myTraining = documentSnapshot.data()!;
    // My Training
    Map<String, dynamic> trainingMap = myTraining['training'] ?? {};
    // Sub training section
    var uuid = const Uuid().v4();

    Map<String, dynamic> trainingSectionMap = {
      'id': uuid,
      'order': order,
      'title': title,
      'section-training': workout,
    };

    trainingMap[uuid] = trainingSectionMap;

    await _dreamCollection.doc(doc).update({
      'training': trainingMap,
    });
  }

  // EDII
  Future<void> updateTrainingSection({
    required String doc,
    required int order,
    required String title,
    required List<String> workout,
    required String id,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _getDocSnap(doc);
    if (!documentSnapshot.exists) return;
    // My Training Map
    Map<String, dynamic> myTraining = documentSnapshot.data()!;
    // My Training
    Map<String, dynamic> trainingMap = myTraining['training'] ?? {};
    // Sub training section

    Map<String, dynamic> trainingSectionMap = trainingMap[id] ?? {};

    if (trainingMap[id] == null) {
      trainingSectionMap['id'] = id;
    }
    trainingSectionMap['order'] = order;
    trainingSectionMap['title'] = title;
    trainingSectionMap['section-training'] = workout;

    trainingMap[id] = trainingSectionMap;

    await _dreamCollection.doc(doc).update({
      'training': trainingMap,
    });
  }

  Future<void> deleteTrainingSection({
    required String doc,
    required String id,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _getDocSnap(doc);
    if (!documentSnapshot.exists) return;
    // My Training Map
    Map<String, dynamic> myTraining = documentSnapshot.data()!;
    // My Training
    Map<String, dynamic> trainingMap = myTraining['training'];
    trainingMap.remove(id);
    await _dreamCollection.doc(doc).update({
      'training': trainingMap,
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getDocSnap(String doc) =>
      _dreamCollection.doc(doc).get();
}
