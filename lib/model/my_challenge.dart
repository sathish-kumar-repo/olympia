import 'package:cloud_firestore/cloud_firestore.dart';

class MyChallenge {
  String docId;
  String myChallenge;
  String description;
  String myPlan;
  DateTime challengeStartDate;
  DateTime challengeEndDate;
  Map<String, List> track;

  MyChallenge({
    required this.docId,
    required this.myChallenge,
    required this.description,
    required this.myPlan,
    required this.challengeStartDate,
    required this.challengeEndDate,
    required this.track,
  });

  // factory MyChallenge.fromMap(Map data) {
  //   return MyChallenge(
  //     docId: data['id'],
  //     myChallenge: data['myChallenge'],
  //     description: data['description'],
  //     myPlan: data['myPlan'],
  //     challengeStartDate: data['challengeStartDate'].toDate(),
  //     challengeEndDate: data['challengeEndDate'].toDate(),
  //     track: _getCorrectTrackMap(data['track']),
  //   );
  // }

  factory MyChallenge.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    Map data = doc.data()!;
    // doc.id
    return MyChallenge(
      docId: data['id'],
      myChallenge: data['myChallenge'],
      description: data['description'],
      myPlan: data['myPlan'],
      challengeStartDate: data['challengeStartDate'].toDate(),
      challengeEndDate: data['challengeEndDate'].toDate(),
      track: _getCorrectTrackMap(data['track']),
    );
  }
}

Map<String, List<dynamic>> _getCorrectTrackMap(Map currentMap) {
  Map<String, List<dynamic>> map = {};

  // Order the map elements based on the Timestamp values
  List<MapEntry> sortedEntries = currentMap.entries.toList()
    ..sort(
        (a, b) => (a.value[2] as Timestamp).compareTo(b.value[2] as Timestamp));
// Convert the sorted entries back to a map
  Map sortedMap = Map.fromEntries(sortedEntries);
  sortedMap.forEach((key, value) {
    map[key] = [
      value[0],
      value[1],
      value[2].toDate(),
    ];
  });
  return map;
}
