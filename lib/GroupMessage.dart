import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/models/UserSingleton.dart';

class GroupMessage extends StatefulWidget {
  Function()? refresh;
  String last_msg, last_sender_fName, last_sender_lName;
  String profile_picture, id, eventName, eventType;
  List users;
  GroupMessage(
      {this.refresh,
      required this.last_msg,
      required this.eventType,
      this.last_sender_fName = "",
      this.last_sender_lName = "",
      required this.id,
      required this.eventName,
      required this.users,
      this.profile_picture = ""});
  @override
  _GroupMessageState createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  bool ready = false;
  UserSingleton userSingleton = UserSingleton();
  TextEditingController controller = TextEditingController();
  Map<String, Map<String, String>> user_widgets = {};
  String title = "";

  void handleMessageSubmit(String msg) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var msgCollection =
        await firestore.collection("group_messages").doc(widget.id).get();

    if (msgCollection.exists) {
      var data = msgCollection.data() as Map;
      var new_usersList = [];
      for (var user in data['users']) {
        new_usersList.add(user);
      }
      if (!new_usersList.contains(userSingleton.user!.email))
        new_usersList.add(userSingleton.user!.email);
      await firestore.collection("group_messages").doc(widget.id).update({
        "users": new_usersList,
        "last_sender": userSingleton.user!.email,
        "last_msg": msg,
      });
    }

    msgCollection.reference.collection("messages").add({
      "message": msg,
      "sender": userSingleton.user!.email,
      "timestamp": DateTime.now()
    });
  }

  Future<void> retrieveAllUsers() async {
    FirebaseFirestore.instance
        .collection(widget.eventType)
        .doc(widget.id)
        .get()
        .then((value) {
      var data = value.data() as Map;
      setState(() {
        title = data['name'];
      });
    });
    for (var user in widget.users) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var user_doc = await firestore.collection("users").doc(user).get();
      if (user_doc.exists) {
        var data = user_doc.data() as Map;
        setState(() {
          user_widgets[data['email']] = {
            "profile_picture": data['profile_picture'] ?? "",
            "first_name": data['first_name'],
            "last_name": data['last_name'],
            "email": data['email']
          };
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    retrieveAllUsers().then((value) => setState(() {
          ready = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text("VT"),
          Text(" "),
          Text(
            "Ready",
            style: TextStyle(color: Color(0xFFFCCD00)),
          ),
          Expanded(child: SizedBox.shrink()),
          Icon(Icons.notifications),
          SizedBox(
            width: 16,
          ),
          Icon(Icons.menu)
        ]),
        elevation: 0,
        backgroundColor: Color(0xFF102733),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("group_messages")
              .doc(widget.id)
              .collection("messages")
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (ready) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      Text(
                        "${title}",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 12,
                      ),
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
                            else if (data['sender'] == "system")
                              return Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    data['message'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ));

                            return Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  if (user_widgets[data['sender']]![
                                          'profile_picture'] as String !=
                                      "") ...[
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundImage: NetworkImage(
                                          user_widgets[data['sender']]![
                                              'profile_picture'] as String),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    )
                                  ] else ...[
                                    Icon(Icons.person,
                                        size: 32, color: Colors.white),
                                    SizedBox(
                                      width: 12,
                                    )
                                  ],
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(32)),
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      data['message'],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )
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
                          "You can write your first message to ${title} here. All members will see it.",
                          textAlign: TextAlign.center,
                        ),
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
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
