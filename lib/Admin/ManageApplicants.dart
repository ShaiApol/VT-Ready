import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/Admin/AdminHome.dart';
import 'package:project_ngo/components.dart';

class Applicants extends StatefulWidget {
  @override
  _ApplicantsState createState() => _ApplicantsState();
}

class _ApplicantsState extends State<Applicants> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AdminTheme,
        child: Scaffold(
          body: SafeArea(
              child: Column(
            children: [
              AdminUpBar(),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where("verified", isEqualTo: false)
                        .where("rejected", isEqualTo: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.all(16),
                          child: Table(
                            border: TableBorder.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 2),
                            children: [
                              TableRow(children: [
                                Column(children: [
                                  Padding(
                                      padding: EdgeInsets.all(2),
                                      child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text('Name',
                                              style:
                                                  TextStyle(fontSize: 20.0))))
                                ]),
                                Column(children: [
                                  Padding(
                                      padding: EdgeInsets.all(2),
                                      child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text('Address',
                                              style:
                                                  TextStyle(fontSize: 20.0))))
                                ]),
                                Column(children: [
                                  Padding(
                                      padding: EdgeInsets.all(2),
                                      child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text('Contact No.',
                                              style:
                                                  TextStyle(fontSize: 20.0))))
                                ]),
                                Column(children: [
                                  Padding(
                                      padding: EdgeInsets.all(2),
                                      child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text('Experiences',
                                              style:
                                                  TextStyle(fontSize: 20.0))))
                                ]),
                                Column(children: [
                                  Padding(
                                      padding: EdgeInsets.all(2),
                                      child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text('Approved',
                                              style:
                                                  TextStyle(fontSize: 20.0))))
                                ]),
                                Column(children: [
                                  Padding(
                                      padding: EdgeInsets.all(2),
                                      child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text('Rejected',
                                              style:
                                                  TextStyle(fontSize: 20.0))))
                                ]),
                              ]),
                              ...snapshot.data!.docs.map((e) {
                                var data = e.data() as Map;
                                var approved = false;
                                return TableRow(children: [
                                  Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                  "${data['first_name']} ${data['last_name']}",
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            )
                                          ])),
                                  Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(data['address'],
                                                    style: TextStyle(
                                                        fontSize: 20.0)))
                                          ])),
                                  Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                    data['phone_number'],
                                                    style: TextStyle(
                                                        fontSize: 20.0)))
                                          ])),
                                  Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text('Experiences',
                                                    style: TextStyle(
                                                        fontSize: 20.0)))
                                          ])),
                                  Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: TextButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection("users")
                                                        .doc(e.id)
                                                        .update(
                                                            {"verified": true});
                                                  },
                                                  child: Text('Approve',
                                                      style: TextStyle(
                                                          fontSize: 20.0)),
                                                ))
                                          ])),
                                  Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: TextButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection("users")
                                                        .doc(e.id)
                                                        .update(
                                                            {"rejected": true});
                                                  },
                                                  child: Text('Reject',
                                                      style: TextStyle(
                                                          fontSize: 20.0)),
                                                ))
                                          ]))
                                ]);
                              })
                            ],
                          ),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
              AdminBottomBar()
            ],
          )),
        ));
  }
}
