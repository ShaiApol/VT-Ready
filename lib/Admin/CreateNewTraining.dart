import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_ngo/Admin/Training.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/firebase_utils/utils.dart';
import 'package:project_ngo/models/UserSingleton.dart';

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

class CreateNewTraining extends StatefulWidget {
  Training? override;
  CreateNewTraining({this.override});
  _CreateNewTrainingState createState() => _CreateNewTrainingState();
}

class _CreateNewTrainingState extends State<CreateNewTraining> {
  DateTime? selectedDate;
  String? month;
  String? day;
  String? year;

  TextEditingController trainingName = TextEditingController();
  TextEditingController trainingDescription = TextEditingController();
  TextEditingController trainingLocation = TextEditingController();
  String trainingNameText = "";
  File? _image;

  bool trainingNameValid = true,
      trainingDateValid = true,
      trainingLocationValid = true,
      trainingDescriptionValid = true,
      trainingPhotoValid = true;

  @override
  void initState() {
    if (widget.override != null) {
      setState(() {
        trainingNameText = widget.override!.name;
        trainingName.text = widget.override!.name;
        trainingDescription.text = widget.override!.description;
        trainingLocation.text = widget.override!.location;
        selectedDate = DateTime(widget.override!.date['year'],
            widget.override!.date['month'], widget.override!.date['day']);
        year = widget.override!.date['year'].toString();
        month = widget.override!.date['month'].toString();
        day = widget.override!.date['day'].toString();
      });
    }
    super.initState();
  }

  Future<void> setUpNewGroupMessage(String id, String trainingName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection("group_messages").doc(id).set({
      "last_sender":
          "Admin ${UserSingleton().user!.fName} ${UserSingleton().user!.lName} started a new training.",
      "last_msg": "system",
      "users": [UserSingleton().user!.email],
      "name": trainingName,
      "activity_type": "trainings"
    });

    await firestore
        .collection("users")
        .doc(UserSingleton().user!.email)
        .update({
      "group_messages": FieldValue.arrayUnion([id])
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        month = picked.month.toString();
        day = picked.day.toString();
        year = picked.year.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: data,
        child: Scaffold(
          body: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SubTitleText(
                            text: "VT Ready",
                            align: TextAlign.start,
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      SubTitleText(
                        text: trainingNameText.isNotEmpty
                            ? trainingNameText
                            : "New Training",
                        align: TextAlign.start,
                      ),
                      Text("Training Name"),
                      if (trainingNameValid == false)
                        Text("Training Name is required",
                            style: TextStyle(color: Colors.red)),
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF29404E),
                                  borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      trainingNameText = value;
                                    });
                                  },
                                  controller: trainingName,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Enter training name",
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text("Training Date"),
                      if (trainingDateValid == false)
                        Text("Training Date is required",
                            style: TextStyle(color: Colors.red)),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFF29404E)),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                  ),
                                  onPressed: () => _selectDate(context),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      selectedDate != null
                                          ? '$month / $day / $year'
                                          : 'Select Training Date',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ))),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Training Location"),
                      if (trainingLocationValid == false)
                        Text("Training Location is required",
                            style: TextStyle(color: Colors.red)),
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF29404E),
                                  borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: trainingLocation,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Enter training location",
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ))
                        ],
                      ),
                      Text("Training Description"),
                      if (trainingDescriptionValid == false)
                        Text("Training Description is required",
                            style: TextStyle(color: Colors.red)),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xFF29404E),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            controller: trainingDescription,
                            maxLines: 8,
                            decoration:
                                InputDecoration(border: InputBorder.none)),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Training Photo"),
                      SizedBox(
                        height: 8,
                      ),
                      if (trainingPhotoValid == false)
                        Text("Training Photo is required",
                            style: TextStyle(color: Colors.red)),
                      Container(
                          height: 120,
                          child: InkWell(
                            onTap: () async {
                              XFile? file = await ImagePicker.platform
                                  .getImage(source: ImageSource.gallery);
                              setState(() {
                                _image = File(file!.path);
                              });
                            },
                            child: DottedBorder(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Tap to Add Photo Here",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16),
                                        ))
                                      ],
                                    ),
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 64,
                                    )
                                  ],
                                ),
                              ),
                              dashPattern: [8, 4],
                            ),
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 48,
                        child: Row(
                          children: [
                            Expanded(
                                child: DottedBorder(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                        _image?.path ?? "No Image Selected")))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    var no_errors = true;

                                    if (selectedDate == null) {
                                      setState(() {
                                        trainingDateValid = false;
                                      });
                                      no_errors = false;
                                    }

                                    if (trainingNameText.isEmpty) {
                                      setState(() {
                                        trainingNameValid = false;
                                      });
                                      no_errors = false;
                                    }

                                    if (trainingDescription.text.isEmpty) {
                                      setState(() {
                                        trainingDescriptionValid = false;
                                      });
                                      no_errors = false;
                                    }

                                    if (_image == null) {
                                      setState(() {
                                        trainingPhotoValid = false;
                                      });
                                      no_errors = false;
                                    }

                                    if (no_errors) {
                                      FirebaseFirestore firestore =
                                          FirebaseFirestore.instance;
                                      FirebaseStorage storage =
                                          FirebaseStorage.instance;

                                      if (widget.override != null) {
                                        firestore
                                            .collection("trainings")
                                            .doc(widget.override!.id)
                                            .update({
                                          "attendees": [],
                                          "date":
                                              serializeDateTimeToDateofBirth(
                                                  selectedDate!,
                                                  number: true),
                                          "description":
                                              trainingDescription.text,
                                          "location": trainingLocation.text,
                                          "name": trainingName.text,
                                        }).then((value) {
                                          storage
                                              .ref(widget.override!.id)
                                              .putFile(_image!)
                                              .then((p0) {
                                            p0.ref.getDownloadURL().then((url) {
                                              firestore
                                                  .collection("trainings")
                                                  .doc(widget.override!.id)
                                                  .update({"photo": url}).then(
                                                      (value) {
                                                Navigator.pop(context);
                                              });
                                            });
                                          });
                                        });
                                      } else {
                                        firestore.collection("trainings").add({
                                          "attendees": [],
                                          "date":
                                              serializeDateTimeToDateofBirth(
                                                  selectedDate!,
                                                  number: true),
                                          "description":
                                              trainingDescription.text,
                                          "location": trainingLocation.text,
                                          "name": trainingName.text,
                                          "cancelled": false,
                                        }).then((value) async {
                                          await setUpNewGroupMessage(
                                              value.id, trainingName.text);

                                          storage
                                              .ref(value.id)
                                              .putFile(_image!)
                                              .then((p0) {
                                            p0.ref.getDownloadURL().then((url) {
                                              firestore
                                                  .collection("trainings")
                                                  .doc(value.id)
                                                  .update({"photo": url}).then(
                                                      (value) {
                                                Navigator.pop(context);
                                              });
                                            });
                                          });
                                        });
                                      }
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFFFCCD00)),
                                  ),
                                  child: Text(
                                    "Save",
                                    style: TextStyle(color: Colors.black),
                                  ))),
                          SizedBox(width: 16),
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xFF95D1F3))),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.black),
                                  )))
                        ],
                      )
                    ],
                  ),
                )),
                Container(
                  height: 96,
                  decoration: BoxDecoration(color: Color(0xFF95D1F3)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        height: 56,
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(48))),
                        width: 140,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.house,
                              color: Color(0xFFFFA700),
                              size: 32,
                            ),
                            Text(
                              "Home",
                              style: TextStyle(
                                  color: Color(0xFFFFA700),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      Icon(
                        Icons.search,
                        size: 32,
                        color: Colors.black,
                      ),
                      Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.black,
                      )
                    ],
                  ),
                )
              ])),
        ));
  }
}
