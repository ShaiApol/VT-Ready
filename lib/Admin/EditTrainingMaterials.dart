import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/Admin/UploadFilesToTraining.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/models/Training.dart';
import 'package:project_ngo/utils.dart';

ThemeData AdminTheme = ThemeData(
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

class EditTrainingMaterials extends StatefulWidget {
  EditTrainingMaterials({Key? key}) : super(key: key);

  @override
  _EditTrainingMaterialsState createState() => _EditTrainingMaterialsState();
}

class _EditTrainingMaterialsState extends State<EditTrainingMaterials> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AdminTheme,
        child: Scaffold(
          body: SafeArea(
              child: FutureBuilder(
                  future:
                      FirebaseFirestore.instance.collection("trainings").get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        padding: EdgeInsets.all(16),
                        children: [
                          SubTitleText(
                            text: "Edit Training Resources",
                            align: TextAlign.start,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Trainings",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 16),
                          ...snapshot.data!.docs.map((e) {
                            var doc = e.data() as Map<String, dynamic>;
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UploadFilesToTraining(
                                                training: Training(
                                                    id: e.id,
                                                    name: doc['name'],
                                                    description:
                                                        doc['description'],
                                                    date: doc['date'],
                                                    location: doc['location'],
                                                    photo: doc['photo']),
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xFF283F4D)),
                                  clipBehavior: Clip.hardEdge,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                        padding: EdgeInsets.only(left: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doc['name'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_month,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  retrieveStringFormattedDate(
                                                      doc['date']),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                            Row(children: [
                                              Icon(
                                                Icons.location_pin,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                doc['location'],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ]),
                                          ],
                                        ),
                                      )),
                                      Image.network(
                                        doc['photo'],
                                        height: 96,
                                        width: 96,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Expanded(
                              child: Center(child: CircularProgressIndicator()))
                        ],
                      );
                    }
                  })),
        ));
  }
}
