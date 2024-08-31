import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:olympia/model/my_challenge.dart';
import 'package:olympia/utils/my_challenge_fn.dart';
import 'package:olympia/utils/sound.dart';
import 'package:uuid/uuid.dart';

class ChallengeFirestoreService {
  // Collection Reference
  final CollectionReference<Map<String, dynamic>> _challengeCollection =
      FirebaseFirestore.instance.collection('challenge');

  // // CHALLENGE STREAM
  // Stream<QuerySnapshot<Map<String, dynamic>>> getChallengeStream() {
  //   return _challengeCollection.snapshots();
  // }

  // // GET LIST OF ALL CHALLENGE
  // List<MyChallenge> getChallengeList(
  //     AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
  //   try {
  //     final challengeList = snapshot.data!.docs.map((doc) {
  //       return MyChallenge.fromFirestore(doc);
  //     }).toList();
  //     return challengeList;
  //   } catch (e) {
  //     return [];
  //   }
  // }

// CHALLENGE STREAM
  Stream<List<MyChallenge>> getChallengeStream() {
    return _challengeCollection.snapshots().map((snapshot) => snapshot.docs
        .map(
          (doc) => MyChallenge.fromFirestore(doc),
        )
        .toList());
  }

  // SINGLE CHALLENGE STREAM
  Stream<MyChallenge> streamChallenge(String id) {
    return _challengeCollection
        .doc(id)
        .snapshots()
        .map((snap) => MyChallenge.fromFirestore(snap));
  }

  // ADD:
  Future<void> addChallenge({
    required String myChallenge,
    required String description,
    required String myPlan,
    required DateTime challengeStartDate,
    required DateTime challengeEndDate,
    required int howManyDays,
  }) async {
    Map<String, List<dynamic>> track = generateChallengeTrack(
      howManyDays: howManyDays,
      startDate: challengeStartDate,
    );
    var uuid = const Uuid().v4();

    await _challengeCollection.doc(uuid).set({
      'id': uuid,
      'myChallenge': myChallenge,
      'description': description,
      'myPlan': myPlan,
      'challengeStartDate': challengeStartDate,
      'challengeEndDate': challengeEndDate,
      'track': track,
    });
  }

  // EDIT
  Future<void> editChallenge({
    required String docId,
    required String myChallenge,
    required String description,
  }) async {
    await _challengeCollection.doc(docId).update({
      'myChallenge': myChallenge,
      'description': description,
    });
  }

  Future<void> editMyPlan({
    required String docId,
    required String myPlan,
  }) async {
    await _challengeCollection.doc(docId).update({
      'myPlan': myPlan,
    });
  }

  // DELETE
  Future<void> deleteChallenge(String docId) async {
    await _challengeCollection.doc(docId).delete();
  }

  // UPDATE DAILY PROGRESS
  Future<void> updateProgress({
    required String docId,
    required DateTime date,
  }) async {
    final String formattedDate = getFormattedDate(date);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _challengeCollection.doc(docId).get();

    if (!documentSnapshot.exists) return;

    Map<String, dynamic> myChallenge = documentSnapshot.data()!;

    Map<String, List<dynamic>> track =
        Map<String, List<dynamic>>.from(myChallenge['track']);

    List<dynamic>? trackForDate = track[formattedDate];
    if (trackForDate == null || trackForDate.isEmpty) return;

    bool currentValue = trackForDate[0] as bool;
    track[formattedDate]![0] = !currentValue;

    if (track[formattedDate]![0] as bool) {
      audioExperience(audioExperienceType: AudioExperienceType.finish);
    }

    await _challengeCollection.doc(docId).update({'track': track});
  }

  // NOTES(ADD AND EDIT)
  Future<void> addAndEditNote({
    required String docId,
    required String note,
    required DateTime date,
  }) async {
    final String formattedDate = getFormattedDate(date);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _challengeCollection.doc(docId).get();
    if (!documentSnapshot.exists) return;

    Map<String, dynamic> myChallenge = documentSnapshot.data()!;
    Map<String, List<dynamic>> track =
        Map<String, List<dynamic>>.from(myChallenge['track']);

    if (!track.containsKey(formattedDate)) return;
    track[formattedDate]![1] = note;
    await _challengeCollection.doc(docId).update({'track': track});
  }

  // DELETE NOTES
  Future<void> deleteNote({
    required String docId,
    required DateTime date,
  }) async {
    final String formattedDate = getFormattedDate(date);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _challengeCollection.doc(docId).get();
    if (!documentSnapshot.exists) return;

    Map<String, dynamic> myChallenge = documentSnapshot.data()!;
    Map<String, List<dynamic>> track =
        Map<String, List<dynamic>>.from(myChallenge['track']);

    if (!track.containsKey(formattedDate)) return;
    track[formattedDate]![1] = '';

    await _challengeCollection.doc(docId).update({'track': track});
  }

  // UPDATE CHALLENGE TRACK
  Future<void> updateChallengeTrack({
    required String docId,
    required int howManyDays,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _challengeCollection.doc(docId).get();
    if (!documentSnapshot.exists) return;

    Map<String, dynamic> myChallenge = documentSnapshot.data()!;
    Map<String, List<dynamic>> track =
        Map<String, List<dynamic>>.from(myChallenge['track']);
    List<List<dynamic>> valueLst = track.values.toList();

    DateTime startDate = (valueLst[valueLst.length - 1][2].toDate())
        .add(const Duration(days: 1));
    String formattedDate;

    for (int i = 0; i < howManyDays; i++) {
      DateTime generateDate = startDate.add(Duration(days: i));
      formattedDate = getFormattedDate(generateDate);
      track[formattedDate] = [false, '', Timestamp.fromDate(generateDate)];
    }

    List<List<dynamic>> newValueLst = track.values.toList();

    await _challengeCollection.doc(docId).update({
      'challengeEndDate': newValueLst[newValueLst.length - 1][2],
      'track': track,
    });
  }

  // Future<DocumentSnapshot> getData(String docId) async {
  //   return await _challengeCollection.doc(docId).get();
  // }

  // getChallenge(String id) async {
  //   DocumentSnapshot<Map<String, dynamic>> snap =
  //       await _challengeCollection.doc(id).get();
  //   return MyChallenge.fromMap(snap.data()!);
  // }
}

  /// Query a subcollection
  // Stream<List<Weapon>> streamWeapons (Firebase User user) {
  // var ref = _db.collection('heroes').document(user.uid).collection('weapons');
  // return ref.snapshots().map((list) =>
  // list.documents.map((doc) => Weapon. from Firestore (doc)).toList());
  // }

