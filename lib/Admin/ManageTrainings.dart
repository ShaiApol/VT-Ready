import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/Admin/Training.dart';
import 'package:project_ngo/components.dart';

import 'CreateNewTraining.dart';

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

class ManageTrainings extends StatefulWidget {
  @override
  _ManageTrainingsState createState() => _ManageTrainingsState();
}

class _ManageTrainingsState extends State<ManageTrainings> {
  int length = 0;
  Future<List<QueryDocumentSnapshot>> getTrainings() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var query = await firestore.collection("trainings").get();
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
                    SubTitleText(
                      text: "Manage Trainings",
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text("Trainings Available"),
                    SizedBox(
                      height: 16,
                    ),
                    Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("trainings")
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
                                                  clipBehavior: Clip.hardEdge,
                                                  color: Color(0xFF283F4D),
                                                  child: Container(
                                                    height: 105,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                            child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 12,
                                                                        left:
                                                                            12),
                                                                child: Header3(
                                                                  text: data[
                                                                      "name"],
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            12),
                                                                child: Text(
                                                                  data[
                                                                      "description"],
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Training training = Training(
                                                                            id: e
                                                                                .id,
                                                                            name:
                                                                                data['name'],
                                                                            description: data['description'],
                                                                            date: data['date'],
                                                                            location: data['location'],
                                                                            photo: data['photo']);
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                          builder:
                                                                              (context) {
                                                                            return CreateNewTraining(
                                                                              override: training,
                                                                            );
                                                                          },
                                                                        ));
                                                                      },
                                                                      child: Text(
                                                                          "Edit")),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        var cancel = await showModalBottomSheet(
                                                                            context: context,
                                                                            builder: (context) {
                                                                              return Container(
                                                                                padding: EdgeInsets.all(16),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Expanded(child: SizedBox.shrink()),
                                                                                    Text(
                                                                                      "Are you sure you want to cancel this activity?",
                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 16,
                                                                                    ),
                                                                                    Text(
                                                                                      "Doing so will send a notification to all registered participants in the form of an announcement and a system message in the activity's group chat.",
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 32,
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                      children: [
                                                                                        ElevatedButton(
                                                                                            onPressed: () {
                                                                                              Navigator.pop(context, true);
                                                                                            },
                                                                                            child: Text("Yes")),
                                                                                        ElevatedButton(
                                                                                            onPressed: () {
                                                                                              Navigator.pop(context, false);
                                                                                            },
                                                                                            child: Text("No"))
                                                                                      ],
                                                                                    ),
                                                                                    Expanded(child: SizedBox.shrink())
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            });

                                                                        if (cancel) {
                                                                          FirebaseFirestore
                                                                              firestore =
                                                                              FirebaseFirestore.instance;
                                                                          await firestore
                                                                              .collection(
                                                                                  "trainings")
                                                                              .doc(e
                                                                                  .id)
                                                                              .update({
                                                                            "cancelled":
                                                                                true
                                                                          });

                                                                          await firestore
                                                                              .collection("announcements")
                                                                              .add({
                                                                            "name":
                                                                                "${(e.data() as Map)['name']} Cancelled",
                                                                            "description":
                                                                                "The training ${(e.data() as Map)['name']} has been cancelled.",
                                                                            "photo":
                                                                                (e.data() as Map)['photo']
                                                                          });
                                                                        } else {
                                                                          FirebaseFirestore
                                                                              firestore =
                                                                              FirebaseFirestore.instance;
                                                                          firestore
                                                                              .collection(
                                                                                  "trainings")
                                                                              .doc(e
                                                                                  .id)
                                                                              .update({
                                                                            "cancelled":
                                                                                false
                                                                          });
                                                                        }
                                                                      },
                                                                      child: (e.data() as Map)[
                                                                              'cancelled']
                                                                          ? Text(
                                                                              "Cancelled")
                                                                          : Text(
                                                                              "Cancel"))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                        if (data['photo'] !=
                                                            null)
                                                          Container(
                                                            height: 105,
                                                            width: 105,
                                                            child:
                                                                Image.network(
                                                              data['photo'],
                                                              height: 105,
                                                              width: 105,
                                                              fit: BoxFit.cover,
                                                            ),
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
                                    child: Text("No Trainings Available"),
                                  );
                                }
                              }
                            })),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CreateNewTraining();
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
                            Text("Add New Training",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16)),
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
                    ),
                  ],
                ),
              )),
              AdminBottomBar()
            ],
          ),
        )));
  }
}
