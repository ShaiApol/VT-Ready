import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/Admin/CreateNewAnnouncement.dart';
import 'package:project_ngo/components.dart';

import 'Announcement.dart';
import 'CreateNewReward.dart';

ThemeData data = ThemeData(
    primaryColor:
        const Color(0xFFFDCD01), // Primary color for app bars, buttons, etc.
    highlightColor: const Color(
        0xFFFDCD01), // Highlight color for text fields, buttons, etc.
    scaffoldBackgroundColor:
        const Color(0xFFFFFFFF), // Background color for all pages
    textTheme: TextTheme(
        bodyLarge: TextStyle(
            color: Colors.black), // Set the default text color to white
        bodyMedium: TextStyle(color: Colors.black),
        bodySmall: TextStyle(
            color: Colors.black), // Set the default text color to white
        titleMedium: TextStyle(color: Colors.black)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color(0xFF47A6DF)), // Set the color of the ElevatedButton
      ),
    )
    // You can customize more theme properties here if needed
    );

class ManageAnnouncements extends StatefulWidget {
  @override
  _ManageAnnouncementsState createState() => _ManageAnnouncementsState();
}

class _ManageAnnouncementsState extends State<ManageAnnouncements> {
  int length = 0;
  Future<List<QueryDocumentSnapshot>> getRewards() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var query = await firestore.collection("announcements").get();
    setState(() {
      length = query.docs.length;
    });
    return query.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: data,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Manage Announcements'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubTitleText(
                  text: "Manage Announcements",
                ),
                SizedBox(
                  height: 16,
                ),
                Text("Announcements"),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("announcements")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError)
                            return Text('Error: ${snapshot.error}');
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if (snapshot.hasData) {
                              return ListView(
                                children: [
                                  ...snapshot.data!.docs.map((e) {
                                    var data = e.data() as Map;
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: InkWell(
                                            onTap: () {},
                                            child: Card(
                                              color: Color(0xFF283F4D),
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 16),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Header3(
                                                          text: data["name"],
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          child: Text(
                                                            data["description"],
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (context) {
                                                                    return CreateNewAnnouncement(
                                                                        announcementOverride: Announcement(
                                                                            id: e
                                                                                .id,
                                                                            name:
                                                                                data["name"],
                                                                            content: data["description"],
                                                                            photo: data["photo"]));
                                                                  }));
                                                                },
                                                                child: Text(
                                                                    "Edit")),
                                                            TextButton(
                                                                onPressed: () {
                                                                  FirebaseFirestore
                                                                      firestore =
                                                                      FirebaseFirestore
                                                                          .instance;
                                                                  firestore
                                                                      .collection(
                                                                          "announcements")
                                                                      .doc(e.id)
                                                                      .delete();
                                                                },
                                                                child: Text(
                                                                    "Delete"))
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ))
                                        ],
                                      ),
                                    );
                                  })
                                ],
                              );
                            } else {
                              return Center(
                                child: Text("No Rewards Available"),
                              );
                            }
                          }
                        })),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CreateNewAnnouncement();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFDCD01),
                    onPrimary: Colors.black,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Add New Announcement",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.add,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
