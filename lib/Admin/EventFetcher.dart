import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'Event.dart';

class EventFetcher {
  String email;

  EventFetcher({required this.email});

  Future<List<Event>> fetch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<Event> events = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firestore.collection('events').get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();

      events.add(Event(
        id: doc.id,
        name: data['name'],
        description: data['description'],
        date: data['date'],
        location: data['location'],
        photo: data['photo'],
        attendees: data['attendees'] ?? null,
        present: data['present'] ?? null,
        certificates: data['certificates'] ?? null,
      ));
    }
    return events;
  }
}
