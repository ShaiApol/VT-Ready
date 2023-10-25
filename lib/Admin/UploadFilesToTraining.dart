import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/models/Training.dart';

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

class UploadFilesToTraining extends StatefulWidget {
  Training training;
  UploadFilesToTraining({Key? key, required this.training}) : super(key: key);

  @override
  _UploadFilesToTrainingState createState() => _UploadFilesToTrainingState();
}

class _UploadFilesToTrainingState extends State<UploadFilesToTraining> {
  List<PlatformFile> new_files = [];
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AdminTheme,
        child: Scaffold(
            body: SafeArea(
                child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubTitleText(
                text: widget.training.name,
                align: TextAlign.start,
              ),
              SizedBox(
                height: 24,
              ),
              Text("Upload Materials", style: TextStyle(fontSize: 18)),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Files should be PDF, JPEG, PNG, MP4, or MP3",
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    textAlign: TextAlign.center,
                  ))
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                  height: 180,
                  child: InkWell(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(type: FileType.custom, allowedExtensions: [
                        'pdf',
                        'jpg',
                        'jpeg',
                        'png',
                        'mp4',
                        'mp3'
                      ]);
                      setState(() {
                        new_files = result?.files ?? [];
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
                                  "Tap to Add Files Here",
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
              Expanded(
                  child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("trainings")
                    .doc(widget.training.id)
                    .collection("resources")
                    .get(),
                builder: (context, snapshot) {
                  return ListView(children: [
                    if (new_files.isNotEmpty)
                      ...new_files.map((e) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.folder,
                                size: 32,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text(e.name)
                            ],
                          ),
                        );
                      }),
                    if (snapshot.hasData)
                      ...snapshot.data!.docs.map((e) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.folder,
                                size: 32,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text((e.data() as Map)['filename'])
                            ],
                          ),
                        );
                      })
                  ]);
                },
              )),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFFFCCD00)),
                          ),
                          onPressed: () async {
                            FirebaseStorage storage = FirebaseStorage.instance;
                            var ref = storage.ref();
                            List<Future> futures = [];
                            for (var file in new_files) {
                              futures.add(ref
                                  .child("${widget.training.id}/${file.name}")
                                  .putFile(File(file.path!)));

                              futures.add(FirebaseFirestore.instance
                                  .collection("trainings")
                                  .doc(widget.training.id)
                                  .collection("resources")
                                  .add({
                                "filename": file.name,
                              }));
                            }
                            await Future.wait(futures);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.black),
                          ))),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel")))
                ],
              )
            ],
          ),
        ))));
  }
}
