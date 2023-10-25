import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/Admin/AdminHome.dart';
import 'package:project_ngo/Admin/CertificateGenerator.dart';
import 'package:project_ngo/Admin/Training.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/utils.dart';

class AttendanceMonitoring extends StatefulWidget {
  @override
  _AttendanceMonitoringState createState() => _AttendanceMonitoringState();
}

class _AttendanceMonitoringState extends State<AttendanceMonitoring> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AdminTheme,
        child: Scaffold(
          body: SafeArea(
              child: Column(
            children: [
              AdminUpBar(),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SubTitleText(text: "Attendance Monitoring"),
                            SizedBox(
                              height: 16,
                            ),
                            Text("Trainings"),
                            SizedBox(
                              height: 16,
                            ),
                            Expanded(
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("trainings")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.docs.isNotEmpty) {
                                          return ListView(
                                            children: [
                                              ...snapshot.data!.docs.map((e) {
                                                var data = e.data() as Map;
                                                return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 16),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Training training = Training(
                                                            id: e.id,
                                                            name: data['name'],
                                                            description: data[
                                                                'description'],
                                                            date: data['date'],
                                                            location: data[
                                                                'location'],
                                                            photo:
                                                                data['photo'],
                                                            present: data[
                                                                    'present'] ??
                                                                [],
                                                            lateAttendees: data[
                                                                    'late_attendees'] ??
                                                                []);
                                                        showModalBottomSheet(
                                                            context: context,
                                                            builder: (context) {
                                                              return AttendanceMonitoringPopUp(
                                                                  training:
                                                                      training);
                                                            });
                                                      },
                                                      child: Container(
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          color:
                                                              Color(0xFF283F4D),
                                                        ),
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        child: Row(children: [
                                                          Expanded(
                                                              child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  data['name'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                    height: 8),
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .calendar_month,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Text(
                                                                      retrieveStringFormattedDate(
                                                                          data[
                                                                              'date']),
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                          if (data["photo"] !=
                                                              null)
                                                            Image.network(
                                                              data['photo'],
                                                              height: 100,
                                                              width: 100,
                                                              fit: BoxFit.cover,
                                                            )
                                                        ]),
                                                      ),
                                                    ));
                                              })
                                            ],
                                          );
                                        } else
                                          return Center(
                                              child:
                                                  Text("No trainings found"));
                                      }
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }))
                          ]))),
              AdminBottomBar()
            ],
          )),
        ));
  }
}

class AttendanceMonitoringPopUp extends StatefulWidget {
  Training training;
  AttendanceMonitoringPopUp({required this.training});
  @override
  _AttendanceMonitoringPopUpState createState() =>
      _AttendanceMonitoringPopUpState();
}

Future<List<DocumentSnapshot>> getAllAttendees(Training training) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> docs = [];
  List<dynamic> emails = [];

  var doc = await firestore.collection("trainings").doc(training.id).get();
  emails = (doc.data() as Map)['attendees'];

  for (var email in emails) {
    if (!training.present!.contains(email) ||
        !training.lateAttendees!.contains(email)) {
      print(email);
      var user = await firestore.collection("users").doc(email).get();
      docs.add(user);
    } else {
      print("${email} already has certificates");
    }
  }
  return docs;
}

class _AttendanceMonitoringPopUpState extends State<AttendanceMonitoringPopUp> {
  bool updating = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 100,
                width: 100,
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: Image.network(
                  widget.training.photo,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Checking attendance for"),
                  Text(
                    widget.training.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    retrieveStringFormattedDate(widget.training.date),
                    style: TextStyle(fontSize: 18),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text("Full Name"),
              Expanded(child: SizedBox.shrink()),
              Text("Present"),
              SizedBox(width: 16),
              Text("Late"),
              SizedBox(width: 16),
            ],
          ),
          Expanded(
              child: FutureBuilder(
                  future: getAllAttendees(widget.training),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children: [
                          ...snapshot.data!.map((e) {
                            var data = e.data() as Map;
                            return Row(
                              children: [
                                Text(data['first_name'] +
                                    " " +
                                    data['last_name']),
                                Expanded(child: SizedBox.shrink()),
                                Checkbox(
                                    value:
                                        widget.training.present!.contains(e.id),
                                    onChanged: (value) {
                                      if (value!) {
                                        widget.training.present!.add(e.id);
                                      } else {
                                        widget.training.present!.remove(e.id);
                                      }
                                      setState(() {});
                                    }),
                                Checkbox(
                                    value: widget.training.lateAttendees!
                                        .contains(e.id),
                                    onChanged: (value) {
                                      if (value!) {
                                        widget.training.lateAttendees!
                                            .add(e.id);
                                      } else {
                                        widget.training.lateAttendees!
                                            .remove(e.id);
                                      }
                                      setState(() {});
                                    })
                              ],
                            );
                          })
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.data == null) {
                      return Center(child: Text("No attendees found"));
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  })),
          if (!updating)
            Text(
              "Pressing \"Update Attendance\" will generate certificates to all attendees marked present and/or late, which will be visible in their accounts. This cannot be revoked.",
              textAlign: TextAlign.center,
            )
          else
            CircularProgressIndicator(),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  updating = true;
                });
                await FirebaseFirestore.instance
                    .collection("trainings")
                    .doc(widget.training.id)
                    .update({
                  "present": widget.training.present,
                  "late_attendees": widget.training.lateAttendees
                });

                List<String> allAttendees = [
                  ...widget.training.present!,
                  ...widget.training.lateAttendees!
                ];

                for (var attendee in allAttendees) {
                  CertificateGenerator generator = CertificateGenerator(
                      day: widget.training.date['day'].toString(),
                      month: widget.training.date['month'].toString(),
                      year: widget.training.date['year'].toString(),
                      name: await getUserNameFromFirebase(attendee),
                      training_name: widget.training.name);
                  Uint8List bytes = await generator.generateImage();
                  Image img = Image.memory(bytes);
                  FirebaseStorage storage = FirebaseStorage.instance;
                  var ref = storage
                      .ref()
                      .child('${attendee} - ${widget.training.name}');

                  ref.putData(bytes).then((p0) {
                    ref.getDownloadURL().then((value) {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(attendee)
                          .collection("certificates")
                          .doc(widget.training.id)
                          .set({
                        "activity_id": widget.training.id,
                        "activity_type": "trainings",
                        "certificate_picture": value,
                        "date": {
                          "day": widget.training.date['day'],
                          "month": widget.training.date['month'],
                          "year": widget.training.date['year']
                        },
                      });
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: Text("Update Attendance"))
        ],
      ),
    );
  }
}

Future<String> getUserNameFromFirebase(String email) {
  return FirebaseFirestore.instance
      .collection("users")
      .doc(email)
      .get()
      .then((value) {
    var data = value.data() as Map;
    return data['first_name'] + " " + data['last_name'];
  });
}
