import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/models/RegistrationConfirmation.dart';
import 'package:project_ngo/models/UserSingleton.dart';
import 'package:project_ngo/utils.dart';

import 'Event.dart';

class EventDetails extends StatefulWidget {
  EventDetails({Key? key, required this.event}) : super(key: key);
  final Event event;
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  UserSingleton userSingleton = UserSingleton();
  Future<bool> checkUserStatusOnEvent() async {
    return await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id)
        .get()
        .then((value) {
      List<dynamic> attendees = value.data()!['attendees'];
      if (attendees.contains(userSingleton.user!.email)) {
        log("User already registered for this event");
        return true;
      } else {
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Details"),
        elevation: 0,
        backgroundColor: Color(0xFF102733),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    widget.event.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ))
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(widget.event.photo,
                      height: MediaQuery.of(context).size.height / 3)
                ],
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFF283F4D)),
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Text(
                                retrieveStringFormattedDate(widget.event.date)))
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(child: Text(widget.event.location))
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                  child: ListView(children: [Text(widget.event.description)])),
              SizedBox(
                height: 16,
              ),
            ]),
          )),
          AdminBottomBar()
        ],
      )),
    );
  }
}
