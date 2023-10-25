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
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          Expanded(child: ListView(children: [Text(widget.event.description)])),
          SizedBox(
            height: 16,
          ),
          FutureBuilder(
              future: checkUserStatusOnEvent(),
              builder: (builder, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data! == false) {
                    return ElevatedButton(
                        onPressed: () async {
                          var register = await showModalBottomSheet(
                              context: (context),
                              isScrollControlled: true,
                              builder: (context) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.9,
                                  child: RegistrationConfirmation(),
                                );
                              });
                          if (register) {
                            FirebaseFirestore firestore =
                                FirebaseFirestore.instance;
                            await firestore
                                .collection("events")
                                .doc(widget.event.id)
                                .update({
                              "attendees": FieldValue.arrayUnion(
                                  [userSingleton.user!.email])
                            });

                            await firestore
                                .collection("users")
                                .doc(userSingleton.user!.email)
                                .update({
                              "last_msg":
                                  "${userSingleton.user!.fName} registered for this activity and joined this chat.",
                              "last_sender": "system",
                              "group_messages":
                                  FieldValue.arrayUnion([widget.event.id])
                            });

                            await firestore
                                .collection("users")
                                .doc(userSingleton.user!.email)
                                .update({
                              "group_messages":
                                  FieldValue.arrayUnion([widget.event.id])
                            });

                            Navigator.pop(context);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ));
                  } else {
                    return Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () async {
                            FirebaseFirestore firestore =
                                FirebaseFirestore.instance;

                            await firestore
                                .collection("group_messages")
                                .doc(widget.event.id)
                                .update({
                              "last_msg":
                                  "${userSingleton.user!.fName} cancelled their registration and was removed from this chat.",
                              "last_sender": "system",
                              "users": FieldValue.arrayRemove(
                                  [userSingleton.user!.email])
                            });

                            await firestore
                                .collection("group_messages")
                                .doc(widget.event.id)
                                .collection("messages")
                                .add({
                              "message":
                                  "${userSingleton.user!.fName} cancelled their registration and was removed from this chat.",
                              "sender": "system",
                              "timestamp": DateTime.now()
                            });

                            await firestore
                                .collection("events")
                                .doc(widget.event.id)
                                .update({
                              "attendees": FieldValue.arrayRemove(
                                  [userSingleton.user!.email])
                            });

                            await firestore
                                .collection("users")
                                .doc(userSingleton.user!.email)
                                .update({
                              "group_messages":
                                  FieldValue.arrayRemove([widget.event.id])
                            });

                            await firestore
                                .collection("events")
                                .doc(widget.event.id)
                                .update({
                              "attendees": FieldValue.arrayRemove(
                                  [userSingleton.user!.email])
                            }).then((value) {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                                color: Color(0xFF283F4D),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              "Cancel Registration",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ))
                      ],
                    );
                  }
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                );
              })
        ]),
      )),
    );
  }
}
