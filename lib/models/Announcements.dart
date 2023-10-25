import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/home.dart';

import 'UserSingleton.dart';

class Announcements extends StatefulWidget {
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  UserSingleton userSingleton = UserSingleton();
  Future<bool> getUnreadMessages() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot dc = await firestore
        .collection('users')
        .doc(userSingleton.user!.email)
        .get();

    var dc_data = dc.data() as Map<String, dynamic>;

    for (var message in dc_data['messages']) {
      var message_doc =
          await firestore.collection("messages").doc(message).get();
      var message_doc_data = message_doc.data() as Map<String, dynamic>;

      if (message_doc_data['last_sender'] != userSingleton.user!.email)
        return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
              future: getUnreadMessages(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    return Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(
                                          state_override: "messages",
                                        )));
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF283F4D),
                            ),
                            child: Text(
                              "You have unread messages",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ))
                      ],
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Container();
                }
              }),
          Expanded(
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("announcements")
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                          children: snapshot.data!.docs.map((e) {
                        return Row(
                          children: [
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                //show bottom modal sheet
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        color: Color(0xFF283F4D),
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (e.data()['photo'] != "")
                                              Image.network(
                                                e.data()['photo'],
                                                width: 250,
                                                fit: BoxFit.cover,
                                              ),
                                            SizedBox(height: 16),
                                            Text(
                                              "${e.data()['name']}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                                "${e.data()['description'] ?? ""}"),
                                            SizedBox(height: 8),
                                            Text(
                                                "Posted on ${new DateTime.fromMillisecondsSinceEpoch(e.data()['date'].seconds * 1000) ?? ""}"),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color(0xFF283F4D),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${e.data()['name']}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(e.data()['description'] ?? "")
                                  ],
                                ),
                              ),
                            ))
                          ],
                        );
                      }).toList());
                    }
                    return Container();
                  })),
          BottomBar()
        ],
      )),
    );
  }
}
