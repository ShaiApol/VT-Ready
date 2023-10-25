import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/models/UserSingleton.dart';

import 'ViewOrgProfile.dart';

class OrgMessage extends StatefulWidget {
  Function()? refresh;
  String receipient, fName, lName, role;
  String profile_picture;
  OrgMessage(
      {this.refresh,
      required this.receipient,
      required this.fName,
      required this.lName,
      required this.role,
      this.profile_picture = ""});
  @override
  _OrgMessageState createState() => _OrgMessageState();
}

class _OrgMessageState extends State<OrgMessage> {
  bool ready = false;
  UserSingleton userSingleton = UserSingleton();
  TextEditingController controller = TextEditingController();

  void handleMessageSubmit(String msg) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("users").doc(userSingleton.user!.email).update({
      "messages": FieldValue.arrayUnion([createMessageID()])
    });

    await firestore.collection("users").doc(widget.receipient).update({
      "messages": FieldValue.arrayUnion([createMessageID()])
    });

    await firestore
        .collection("messages")
        .doc("${createMessageID()}")
        .collection("messages")
        .add({
      "message": msg,
      "sender": userSingleton.user!.email,
      "timestamp": DateTime.now()
    });

    await firestore.collection("messages").doc("${createMessageID()}").set({
      "last_message": msg,
    });

    await firestore.collection("messages").doc("${createMessageID()}").update({
      "users": [userSingleton.user!.email, widget.receipient],
      "last_sender": userSingleton.user!.email,
    });
  }

  String createMessageID() {
    var email = userSingleton.user!.email;
    var receipient = widget.receipient;
    var combined = email + receipient;
    var sorted = combined.split("")..sort();

    return sorted.join("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: userSingleton.user!.account_type == "admin"
                            ? AssetImage("assets/images/admin_message.png")
                            : AssetImage("assets/images/fade_background.png"),
                        fit: BoxFit.cover)),
                child: Column(
                  children: [
                    userSingleton.user!.account_type == "admin"
                        ? AdminUpBar()
                        : UpBar(),
                    Expanded(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("messages")
                              .doc("${createMessageID()}")
                              .collection("messages")
                              .orderBy("timestamp", descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  color: userSingleton.user!.account_type ==
                                          "admin"
                                      ? Colors.white
                                      : Color(0xFF112732),
                                  child: Row(children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.arrow_back,
                                        color:
                                            userSingleton.user!.account_type ==
                                                    "admin"
                                                ? Colors.black
                                                : Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Column(
                                      children: [
                                        widget.profile_picture.isNotEmpty
                                            ? Container(
                                                height: 36,
                                                width: 36,
                                                padding: EdgeInsets.all(2),
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Color(0xFFFCCD00),
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24)),
                                                child: Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24)),
                                                  child: Image.network(
                                                    widget.profile_picture,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              )
                                            : Icon(Icons.person,
                                                size: 36,
                                                color: userSingleton.user!
                                                            .account_type ==
                                                        "admin"
                                                    ? Colors.black
                                                    : Colors.white),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(widget.receipient)
                                              .get()
                                              .then((value) async {
                                            var trainings =
                                                await FirebaseFirestore.instance
                                                    .collection("trainings")
                                                    .get();
                                            print(
                                                "Found ${trainings.docs.length} trainings");
                                            var eligibleTrainings = [];

                                            for (var training
                                                in trainings.docs) {
                                              var day = training.data()["date"]
                                                          ['day'] <
                                                      10
                                                  ? "0${training.data()["date"]['day']}"
                                                  : "${training.data()["date"]['day']}";
                                              var month = training
                                                              .data()["date"]
                                                          ['month'] <
                                                      10
                                                  ? "0${training.data()["date"]['month']}"
                                                  : "${training.data()["date"]['month']}";
                                              var year = training.data()["date"]
                                                  ['year'];
                                              var date = DateTime.parse(
                                                  "$year-$month-$day");
                                              print(date);
                                              if (date
                                                  .isBefore(DateTime.now())) {
                                                eligibleTrainings
                                                    .add(training.data());
                                              }
                                            }

                                            print(
                                                "Found ${eligibleTrainings.length} eligible trainings");

                                            var attended = [];

                                            for (var eligible
                                                in eligibleTrainings) {
                                              var attendance =
                                                  eligible['attendees'];

                                              if (attendance
                                                  .contains(widget.receipient))
                                                attended.add(eligible);
                                            }

                                            print(
                                                "Found ${attended.length} attended trainings");

                                            var certs = await FirebaseFirestore
                                                .instance
                                                .collection("users")
                                                .doc(widget.receipient)
                                                .collection("certificates")
                                                .get();

                                            List<Map> certificates = [];
                                            for (var certificate
                                                in certs.docs) {
                                              var data = certificate.data();
                                              var training =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          data['activity_type'])
                                                      .doc(data['activity_id'])
                                                      .get();

                                              certificates.add({
                                                "name": (training.data()
                                                    as Map)['name'],
                                                "certificate":
                                                    data['certificate_picture'],
                                              });
                                            }
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ViewOrgProfile(
                                                  certificates: certificates,
                                                  trainings: attended,
                                                  role: widget.role,
                                                  userToView:
                                                      value.data() as Map);
                                            }));
                                          });
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${widget.fName} ${widget.lName}",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: userSingleton.user!
                                                              .account_type ==
                                                          "admin"
                                                      ? Colors.black
                                                      : Colors.white),
                                            ),
                                            Text(
                                              widget.role,
                                              style: TextStyle(
                                                  color: userSingleton.user!
                                                              .account_type ==
                                                          "admin"
                                                      ? Colors.black
                                                      : Colors.white),
                                            )
                                          ],
                                        ))
                                  ]),
                                ),
                                if (snapshot.hasData)
                                  if (snapshot.data!.docs.isNotEmpty)
                                    Expanded(
                                        child: ListView(
                                      reverse: true,
                                      children: [
                                        ...snapshot.data!.docs.map((e) {
                                          var data = e.data() as Map;
                                          if (data['sender'] ==
                                              userSingleton.user!.email)
                                            return Padding(
                                              padding: EdgeInsets.all(16),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: SizedBox.shrink()),
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(32)),
                                                    padding: EdgeInsets.all(12),
                                                    child: Text(
                                                      data['message'],
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  if (widget.profile_picture
                                                      .isNotEmpty)
                                                    Container(
                                                      height: 32,
                                                      width: 32,
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xFFFCCD00),
                                                              width: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24)),
                                                      child: Container(
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        24)),
                                                        child: Image.network(
                                                          widget
                                                              .profile_picture,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    )
                                                  else
                                                    Icon(Icons.person,
                                                        size: 32,
                                                        color: Colors.white),
                                                ],
                                              ),
                                            );

                                          return Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                    radius: 16,
                                                    backgroundImage:
                                                        NetworkImage(widget
                                                            .profile_picture)),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                Expanded(
                                                    child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32)),
                                                  padding: EdgeInsets.all(12),
                                                  child: Text(
                                                    data['message'],
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          );
                                        })
                                      ],
                                    ))
                                  else
                                    Expanded(
                                        child: Center(
                                      child: Text(
                                          "You can write your first message to ${widget.fName} here."),
                                    )),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(32)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: TextFormField(
                                            controller: controller,
                                            onFieldSubmitted: (value) {
                                              handleMessageSubmit(value);
                                              controller.text = "";
                                            },
                                            textInputAction: TextInputAction.go,
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                                border: InputBorder.none),
                                          )),
                                    ))
                                  ],
                                ),
                                userSingleton.user!.account_type == "admin"
                                    ? AdminBottomBar()
                                    : BottomBar()
                              ],
                            );
                          }),
                    )
                  ],
                ))));
  }
}
