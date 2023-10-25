import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/Admin/AdminHome.dart';
import 'package:project_ngo/Admin/CreateNewEvent.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/utils.dart';

import '../home.dart';

class AddIncidentReport extends StatefulWidget {
  @override
  _AddIncidentReportState createState() => _AddIncidentReportState();
}

class _AddIncidentReportState extends State<AddIncidentReport> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController victimsController = TextEditingController();
  TextEditingController incidentDetailsController = TextEditingController();
  TextEditingController damagesController = TextEditingController();
  TextEditingController resolutionController = TextEditingController();
  TextEditingController repairPlanController = TextEditingController();
  //dropdown state
  String? dropdownValue;
  bool policeNotified = false;
  bool solved = false;
  String name = "";
  Map<String, dynamic>? date;
  TimeOfDay? time;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AdminTheme,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(
          children: [
            AdminUpBar(),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back),
                        SizedBox(
                          width: 16,
                        ),
                        SubTitleText(
                            text: name.isEmpty ? "Add Incident Report" : name)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: ListView(
                            children: [
                              Row(
                                children: [
                                  Text("Name:"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: nameController,
                                      decoration: InputDecoration(),
                                      onChanged: (value) {
                                        setState(() {
                                          name = value;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(children: [
                                Text("Date Occured"),
                                SizedBox(
                                  width: 8,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      DateTime? datePicked =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2024));

                                      if (datePicked != null) {
                                        setState(() {
                                          date = {
                                            "day": datePicked.day,
                                            "month": datePicked.month,
                                            "year": datePicked.year
                                          };
                                        });
                                      }

                                      var timePicked = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now());

                                      setState(() {
                                        time = timePicked;
                                      });
                                    },
                                    child: Text(date != null
                                        ? "${retrieveStringFormattedDate(date!)} | ${time != null ? time!.format(context) : ""}"
                                        : "Select Date"))
                              ]),
                              SizedBox(
                                height: 8,
                              ),
                              Row(children: [
                                Text("Location:"),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: TextField(
                                      controller: locationController,
                                      decoration: InputDecoration()),
                                )
                              ]),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Text("Victims:"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: victimsController,
                                      keyboardType: TextInputType.number,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Text("Incident Type"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: DropdownButton(
                                        value: dropdownValue,
                                        items: <String>[
                                          "",
                                          'Big Waves',
                                          'Coastal Erosion',
                                          'Continuous Rains',
                                          'Disease Outbreak',
                                          'Drought',
                                          'Earthquake',
                                          'El Nino',
                                          'Flashflood',
                                          'Ground Movement',
                                          'Landslide',
                                          'Lightning Strike',
                                          'LPA',
                                          'Northeast Monsoons',
                                          'Sea Swellings',
                                          'Sinkhole',
                                          'Southwest Monsoon',
                                          'Tall End of a Coldfront',
                                          'Thunderstorms',
                                          'Tornadoes',
                                          'Volcanic Activity',
                                          'Wildfire',
                                        ].map((e) {
                                          return DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(
                                              e,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (e) {
                                          setState(() {
                                            dropdownValue = e as String?;
                                          });
                                        }),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Incident Details"),
                              TextField(
                                controller: incidentDetailsController,
                                minLines: 4,
                                maxLines: 4,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Text("Police Notified?"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Checkbox(
                                      value: policeNotified,
                                      onChanged: (value) {
                                        setState(() {
                                          policeNotified = value!;
                                        });
                                      })
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Damages"),
                              TextField(
                                controller: damagesController,
                                minLines: 4,
                                maxLines: 4,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Resolution"),
                              TextField(
                                controller: resolutionController,
                                minLines: 4,
                                maxLines: 4,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Repair Plan"),
                              TextField(
                                controller: repairPlanController,
                                minLines: 4,
                                maxLines: 4,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Text("Solved?"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Checkbox(
                                      value: solved,
                                      onChanged: (value) {
                                        setState(() {
                                          solved = value!;
                                        });
                                      })
                                ],
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            )),
            ElevatedButton(
                onPressed: () async {
                  //lowercase then replace spaces with underscores
                  var incident_type =
                      dropdownValue!.toLowerCase().replaceAll(" ", "_");
                  await FirebaseFirestore.instance
                      .collection("incident_report")
                      .doc("natural_accidents")
                      .update({
                    incident_type: FieldValue.increment(1),
                  });
                  await FirebaseFirestore.instance
                      .collection("incident_report")
                      .doc("natural_accidents")
                      .collection("incidents")
                      .add({
                    "damages": damagesController.text,
                    "date_time": DateTime(date!["year"], date!["month"],
                        date!["day"], time!.hour, time!.minute),
                    "incident_details": incidentDetailsController.text,
                    "location": locationController.text,
                    "name": nameController.text,
                    "police_notified": policeNotified,
                    "repair_plan": repairPlanController.text,
                    "resolution": resolutionController.text,
                    "type": dropdownValue,
                    "solved": solved,
                    "victims": int.parse(victimsController.text)
                  });

                  Navigator.pop(context);
                },
                child: Text("Submit")),
            AdminBottomBar()
          ],
        )),
      ),
    );
  }
}
