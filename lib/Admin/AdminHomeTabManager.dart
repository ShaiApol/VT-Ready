import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_ngo/Admin/AttendanceMonitoring.dart';
import 'package:project_ngo/Admin/EditTrainingMaterials.dart';
import 'package:project_ngo/Admin/Heatmap.dart';
import 'package:project_ngo/Admin/ManageApplicants.dart';
import 'package:project_ngo/Admin/ManageEvents.dart';
import 'package:project_ngo/Admin/ManageTrainings.dart';
import 'package:project_ngo/Admin/Messages.dart';
import 'package:project_ngo/Admin/Volunteers.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/Admin/Calendar.dart';
import 'package:project_ngo/Admin/Training.dart';
import 'package:project_ngo/Admin/TrainingDetails.dart';
import 'package:project_ngo/Admin/ManageRewards.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'Cards.dart';
import 'EditTrainingBudget.dart';
import 'Event.dart';
import 'EventDetails.dart';
import 'EventFetcher.dart';
import 'IncidentReport.dart';
import 'ManageAnnouncements.dart';
import 'Reward.dart';
import 'TrainingFetcher.dart';
import 'RewardFetcher.dart';

class AdminHomeTabManager extends StatefulWidget {
  String state;
  String email;
  AdminHomeTabManager({Key? key, required this.state, required this.email})
      : super(key: key);

  @override
  _AdminHomeTabManagerState createState() => _AdminHomeTabManagerState();
}

class _AdminHomeTabManagerState extends State<AdminHomeTabManager> {
  bool loading = true;
  List<Event> events = [];
  List<Training> trainings = [];
  List<Reward> rewards = [];
  @override
  void initState() {
    super.initState();
    var eventFetcher = EventFetcher(email: widget.email);
    var trainingFetcher = TrainingFetcher(email: widget.email);
    var rewardFetcher = RewardFetcher(email: widget.email);
    List<Future> futures = [
      eventFetcher.fetch().then((value) {
        print("Events processed");
        setState(() {
          events = value;
        });
      }),
      trainingFetcher.fetch().then((value) {
        print("Trainings processed");
        setState(() {
          trainings = value;
        });
      }),
      rewardFetcher.fetch().then((value) {
        print("Rewards processed");
        setState(() {
          rewards = value;
        });
      }),
    ];

    Future.wait(futures).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loading) {
      if (widget.state == "home") {
        return Expanded(
          child: Column(
            children: [
              Header3(
                text: "Admin Dashboard",
                align: TextAlign.center,
              ),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2 / 1,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ManageTrainings();
                                }));
                              },
                              child: Text(
                                "Manage Trainings",
                                textAlign: TextAlign.center,
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ManageEvents();
                                }));
                              },
                              child: Text(
                                "Manage Events",
                                textAlign: TextAlign.center,
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ManageAnnouncements();
                                }));
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero),
                              child: Text(
                                "Manage Accouncements",
                                textAlign: TextAlign.center,
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AttendanceMonitoring();
                                }));
                              },
                              child: Text(
                                "Attendance Monitoring",
                                textAlign: TextAlign.center,
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ManageRewards();
                                }));
                              },
                              child: Text(
                                "Manage Rewards",
                                textAlign: TextAlign.center,
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return IncidentReport();
                                }));
                              },
                              child: Text(
                                "Incident Report",
                                textAlign: TextAlign.center,
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return EditTrainingMaterials();
                                }));
                              },
                              child: Text(
                                "Edit Training Resources",
                                textAlign: TextAlign.center,
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Heatmap();
                                }));
                              },
                              child: Text(
                                "Heatmap of Volunteers",
                                textAlign: TextAlign.center,
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Applicants();
                                }));
                              },
                              child: Text(
                                "Applicants",
                                textAlign: TextAlign.center,
                              )),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return EditTrainingBudget();
                                }));
                              },
                              child: Text(
                                "Manage Training Budget",
                                textAlign: TextAlign.center,
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Volunteers();
                                }));
                              },
                              child: Text(
                                "Volunteers",
                                textAlign: TextAlign.center,
                              )),
                        ],
                      )))
            ],
          ),
        );
      } else if (widget.state == "events") {
        return Expanded(
            child: Container(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Header3(text: "Events"),
              ),
              SizedBox(
                height: 16,
              ),
              if (events.isNotEmpty)
                ...events.map((e) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: e.renderAsRowExpandedCard(onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventDetails(
                                    event: e,
                                  )));
                    }),
                  );
                }).toList()
              else
                Header3(
                  text: "No Events available",
                  align: TextAlign.center,
                )
            ],
          ),
        ));
      } else if (widget.state == "trainings") {
        return Expanded(
            child: Container(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Header3(text: "Popular Trainings"),
              ),
              SizedBox(
                height: 16,
              ),
              if (trainings.isNotEmpty)
                ...trainings.map((e) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: e.renderAsRowExpandedCard(onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrainingDetails(
                                    training: e,
                                  )));
                    }),
                  );
                }).toList()
              else
                Header3(
                  text: "No Trainings available",
                  align: TextAlign.center,
                )
            ],
          ),
        ));
      } else if (widget.state == "calendar") {
        return Expanded(child: Calendar(trainings: trainings, events: events));
      } else if (widget.state == "messages") {
        return Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16, left: 16),
              child:
                  Row(children: [Expanded(child: Header3(text: "Messages"))]),
            ),
            Messages()
          ],
        ));
      } else if (widget.state == "rewards") {
        return Expanded(
            child: Container(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Header3(text: "Rewards"),
              ),
              SizedBox(
                height: 16,
              ),
              if (rewards.isNotEmpty)
                ...rewards.map((e) {
                  return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: e.renderAsRowExpandedCard(onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return e.renderAsBottomModal(context);
                            });
                      }));
                }).toList()
              else
                Header3(
                  text: "No Rewards available",
                  align: TextAlign.center,
                )
            ],
          ),
        ));
      }
    }
    return Expanded(
        child: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
