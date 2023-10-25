import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'Training.dart';

class TrainingFetcher {
  String email;

  TrainingFetcher({required this.email});

  Future<List<Training>> fetch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<Training> trainings = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('trainings')
        .where("photo", isNotEqualTo: "")
        .where("photo", isNotEqualTo: null)
        .get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();

      trainings.add(Training(
        id: doc.id,
        name: data['name'],
        description: data['description'],
        date: data['date'],
        location: data['location'],
        photo: data['photo'] ?? null,
        attendees: data['attendees'] ?? null,
        present: data['present'] ?? null,
        certificates: data['certificates'] ?? null,
      ));
    }
    return trainings;
  }
}
