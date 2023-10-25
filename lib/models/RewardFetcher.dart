import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_ngo/models/Reward.dart';

import 'Training.dart';

class RewardFetcher {
  String email;

  RewardFetcher({required this.email});

  Future<List<Reward>> fetch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<Reward> rewards = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firestore.collection('rewards').get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();

      rewards.add(Reward(
        id: doc.id,
        name: data['name'],
        code: data['code'],
        description: data['description'],
        date: data['date'],
        requirements: data['requirements'],
        photo: data['photo'],
      ));
    }
    return rewards;
  }
}
