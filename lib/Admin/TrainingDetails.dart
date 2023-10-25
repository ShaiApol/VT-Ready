import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/Admin/EditTrainingMaterials.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/models/RegistrationConfirmation.dart';
import 'package:project_ngo/models/UserSingleton.dart';
import 'package:project_ngo/utils.dart';

import 'Training.dart';

class TrainingDetails extends StatefulWidget {
  TrainingDetails({Key? key, required this.training}) : super(key: key);
  final Training training;
  @override
  _TrainingDetailsState createState() => _TrainingDetailsState();
}

class _TrainingDetailsState extends State<TrainingDetails> {
  UserSingleton userSingleton = UserSingleton();
  Future<bool> checkUserStatusOnTraining() async {
    return await FirebaseFirestore.instance
        .collection('trainings')
        .doc(widget.training.id)
        .get()
        .then((value) {
      List<dynamic> attendees = value.data()!['attendees'];
      if (attendees.contains(userSingleton.user!.email)) {
        log("User already registered for this training");
        return true;
      } else {
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AdminTheme,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Training Details"),
            elevation: 0,
            backgroundColor: Color(0xFF102733),
          ),
          body: SafeArea(
              child: Padding(
            padding: EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    widget.training.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ))
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(widget.training.photo,
                      height: MediaQuery.of(context).size.height / 3)
                ],
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0x2354BCF8)),
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.black,
                          size: 16,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Text(retrieveStringFormattedDate(
                                widget.training.date)))
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.black,
                          size: 16,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(child: Text(widget.training.location))
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                  child:
                      ListView(children: [Text(widget.training.description)])),
              SizedBox(
                height: 16,
              ),
            ]),
          )),
        ));
  }
}
