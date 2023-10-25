import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/models/UserSingleton.dart';

class Message extends StatefulWidget {
  Function()? refresh;
  String receipient, fName, lName;
  String profile_picture;
  Message(
      {this.refresh,
      required this.receipient,
      required this.fName,
      required this.lName,
      this.profile_picture = ""});
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
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
                  image: AssetImage("assets/images/fade_background.png"),
                  fit: BoxFit.cover)),
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
                    userSingleton.user!.account_type == "user"
                        ? UpBar()
                        : AdminUpBar(),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        if (widget.profile_picture.isNotEmpty)
                          Container(
                            height: 36,
                            width: 36,
                            padding: EdgeInsets.all(2),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xFFFCCD00), width: 2),
                                borderRadius: BorderRadius.circular(24)),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24)),
                              child: Image.network(
                                widget.profile_picture,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        else
                          Icon(Icons.person, size: 36, color: Colors.white),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          "${widget.fName} ${widget.lName}",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )
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
                              if (data['sender'] == userSingleton.user!.email)
                                return Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Expanded(child: SizedBox.shrink()),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(32)),
                                        padding: EdgeInsets.all(12),
                                        child: Text(
                                          data['message'],
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      if (userSingleton.user!.profilePicture !=
                                          null)
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundImage: NetworkImage(
                                              userSingleton
                                                  .user!.profilePicture!),
                                        )
                                      else
                                        Icon(Icons.person,
                                            size: 32, color: Colors.white),
                                    ],
                                  ),
                                );

                              return Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 16,
                                        backgroundImage: NetworkImage(
                                            widget.profile_picture)),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                        child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(32)),
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        data['message'],
                                        style: TextStyle(color: Colors.black),
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
                                  borderRadius: BorderRadius.circular(32)),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: TextFormField(
                                controller: controller,
                                onFieldSubmitted: (value) {
                                  handleMessageSubmit(value);
                                  controller.text = "";
                                },
                                textInputAction: TextInputAction.go,
                                style: TextStyle(color: Colors.black),
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                              )),
                        ))
                      ],
                    ),
                    BottomBar()
                  ],
                );
              })),
    ));
  }
}
