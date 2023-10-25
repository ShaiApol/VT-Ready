import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/Admin/AdminHome.dart';
import 'package:project_ngo/Admin/CreateNewEvent.dart';
import 'package:project_ngo/components.dart';

class EditIncidentReport extends StatefulWidget {
  DocumentSnapshot data;
  EditIncidentReport({Key? key, required this.data}) : super(key: key);
  @override
  _EditIncidentReportState createState() => _EditIncidentReportState();
}

class _EditIncidentReportState extends State<EditIncidentReport> {
  TextEditingController locationController = TextEditingController();
  TextEditingController victimsController = TextEditingController();
  TextEditingController incidentDetailsController = TextEditingController();
  TextEditingController damagesController = TextEditingController();
  TextEditingController resolutionController = TextEditingController();
  //dropdown state
  String? dropdownValue;
  TextEditingController repairPlanController = TextEditingController();
  bool policeNotified = false;
  bool solved = false;
  DateTime? date;
  TimeOfDay? time;

  @override
  void initState() {
    super.initState();
    Map dataMap = widget.data.data() as Map;
    dropdownValue = dataMap['type'] ?? "";
    locationController.text = dataMap['location'] ?? "";
    victimsController.text = dataMap['victims'].toString() ?? "";
    incidentDetailsController.text = dataMap['incident_details'] ?? "";
    damagesController.text = dataMap['damages'] ?? "";
    resolutionController.text = dataMap['resolution'] ?? "";
    repairPlanController.text = dataMap['repair_plan'] ?? "";
    policeNotified = dataMap['police_notified'] ?? "";
    solved = dataMap['solved'] ?? "";
    date = dataMap['date_time'].toDate();
    time = TimeOfDay.fromDateTime(date!);
  }

  @override
  Widget build(BuildContext context) {
    Map dataMap = widget.data.data() as Map;
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
                        SubTitleText(text: dataMap['name'])
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
                              Row(children: [
                                Text("Date/Time Occured"),
                                SizedBox(
                                  width: 8,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      var new_date = await showDatePicker(
                                          context: context,
                                          initialDate: date ?? DateTime.now(),
                                          firstDate: date ?? DateTime.now(),
                                          lastDate: DateTime(2024));
                                      var new_time = await showTimePicker(
                                          context: context,
                                          initialTime: time ?? TimeOfDay.now());
                                      setState(() {
                                        if (new_date != null &&
                                            new_time != null) {
                                          date = new_date;
                                          time = new_time;
                                        }
                                      });
                                    },
                                    child: Text(
                                        "${date!.day}/${date!.month}/${date!.year} | ${time!.hour}:${time!.minute}"))
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
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: policeNotified,
                                          onChanged: (value) {
                                            setState(() {
                                              policeNotified = value as bool;
                                            });
                                          }),
                                    ],
                                  ),
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
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: solved,
                                          onChanged: (value) {
                                            setState(() {
                                              solved = value as bool;
                                            });
                                          }),
                                    ],
                                  ),
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
                  await FirebaseFirestore.instance
                      .collection("incident_report")
                      .doc("natural_accidents")
                      .collection("incidents")
                      .doc(widget.data.id)
                      .update({
                    "damages": damagesController.text,
                    "date_time": DateTime(date!.year, date!.month, date!.day,
                        time!.hour, time!.minute),
                    "incident_details": incidentDetailsController.text,
                    "location": locationController.text,
                    "police_notified": policeNotified,
                    "type": dropdownValue,
                    "repair_plan": repairPlanController.text,
                    "resolution": resolutionController.text,
                    "solved": solved,
                    "victims": int.parse(victimsController.text)
                  });
                  Navigator.pop(context);
                },
                child: Text("Update")),
            AdminBottomBar()
          ],
        )),
      ),
    );
  }
}
