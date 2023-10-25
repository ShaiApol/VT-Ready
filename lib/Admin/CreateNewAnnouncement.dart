import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/firebase_utils/utils.dart';

import 'Announcement.dart';

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

class CreateNewAnnouncement extends StatefulWidget {
  Announcement? announcementOverride;
  CreateNewAnnouncement({this.announcementOverride});
  _CreateNewAnnouncementState createState() => _CreateNewAnnouncementState();
}

class _CreateNewAnnouncementState extends State<CreateNewAnnouncement> {
  DateTime? selectedDate;
  String? month;
  String? day;
  String? year;

  @override
  void initState() {
    if (widget.announcementOverride != null) {
      announcementName.text = widget.announcementOverride!.name;
      announcementDescription.text = widget.announcementOverride!.content;
      announcementNameText = widget.announcementOverride!.name;
    }
    super.initState();
  }

  bool announcementNameValid = true,
      announcementDateValid = true,
      announcementRequirementsValid = true,
      announcementDescriptionValid = true,
      announcementPhotoValid = true;
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

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  TextEditingController announcementName = TextEditingController();
  TextEditingController announcementDescription = TextEditingController();
  TextEditingController announcementRequirements = TextEditingController();
  String announcementNameText = "";
  File? _image;
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
                        text: announcementNameText.isNotEmpty
                            ? announcementNameText
                            : "New Announcement",
                        align: TextAlign.start,
                      ),
                      Text("Announcement Name"),
                      if (announcementNameValid == false)
                        Text("Announcement Name is required",
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
                                      announcementNameText = value;
                                    });
                                  },
                                  controller: announcementName,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Enter announcement name",
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
                      Text("Announcement Description"),
                      if (announcementDescriptionValid == false)
                        Text("Announcement Description is required",
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
                            controller: announcementDescription,
                            maxLines: 8,
                            decoration:
                                InputDecoration(border: InputBorder.none)),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Announcement Photo"),
                      SizedBox(
                        height: 8,
                      ),
                      if (announcementPhotoValid == false)
                        Text("Announcement Photo is required",
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
                                  onPressed: () {
                                    var no_errors = true;

                                    if (announcementNameText.isEmpty) {
                                      setState(() {
                                        announcementNameValid = false;
                                      });
                                      no_errors = false;
                                    }

                                    if (announcementDescription.text.isEmpty) {
                                      setState(() {
                                        announcementDescriptionValid = false;
                                      });
                                      no_errors = false;
                                    }

                                    if (_image == null) {
                                      setState(() {
                                        announcementPhotoValid = false;
                                      });
                                      no_errors = false;
                                    }

                                    if (no_errors) {
                                      FirebaseFirestore firestore =
                                          FirebaseFirestore.instance;
                                      FirebaseStorage storage =
                                          FirebaseStorage.instance;

                                      if (widget.announcementOverride == null) {
                                        firestore
                                            .collection("announcements")
                                            .add({
                                          "date": DateTime.now(),
                                          "description":
                                              announcementDescription.text,
                                          "name": announcementName.text,
                                        }).then((value) {
                                          storage
                                              .ref(value.id)
                                              .putFile(_image!)
                                              .then((p0) {
                                            p0.ref.getDownloadURL().then((url) {
                                              firestore
                                                  .collection("announcements")
                                                  .doc(value.id)
                                                  .update({"photo": url}).then(
                                                      (value) {
                                                Navigator.pop(context);
                                              });
                                            });
                                          });
                                        });
                                      } else {
                                        firestore
                                            .collection("announcements")
                                            .doc(
                                                widget.announcementOverride!.id)
                                            .update({
                                          "date":
                                              serializeDateTimeToDateofBirth(
                                                  DateTime.now(),
                                                  number: true),
                                          "description":
                                              announcementDescription.text,
                                          "name": announcementName.text,
                                        }).then((value) {
                                          storage
                                              .ref(widget
                                                  .announcementOverride!.id)
                                              .putFile(_image!)
                                              .then((p0) {
                                            p0.ref.getDownloadURL().then((url) {
                                              firestore
                                                  .collection("announcements")
                                                  .doc(widget
                                                      .announcementOverride!.id)
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
