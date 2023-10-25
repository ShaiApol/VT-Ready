import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/Admin/AdminHome.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/models/DateOfBirth.dart';
import 'package:project_ngo/models/UserData.dart';

class Volunteers extends StatefulWidget {
  @override
  _VolunteersState createState() => _VolunteersState();
}

class _VolunteersState extends State<Volunteers> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AdminTheme,
        child: Scaffold(
          body: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminUpBar(),
              Padding(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                  child: Text("List of Volunteers",
                      style: TextStyle(fontSize: 24))),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                      "Tap each name for their complete details and each folder for complete certificates.")),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(16),
                child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("users")
                      .where("verified", isEqualTo: true)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children: [
                          Table(
                            border: TableBorder.all(),
                            children: [
                              TableRow(children: [
                                TableCell(child: Text("Name")),
                                TableCell(child: Text("Address")),
                                TableCell(child: Text("Phone")),
                                TableCell(child: Text("Certificates")),
                                TableCell(child: Text("isActive")),
                              ]),
                              ...snapshot.data!.docs.map((e) {
                                var data = e.data() as Map;
                                return TableRow(children: [
                                  TableCell(
                                      child: TextButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return UserInfo(
                                                      data: UserData(
                                                          fName: data[
                                                              'first_name'],
                                                          lName:
                                                              data['last_name'],
                                                          dob: DateOfBirth(
                                                              year: data['date_of_birth']
                                                                  ['year'],
                                                              month: data['date_of_birth']
                                                                  ['month'],
                                                              day: data['date_of_birth']
                                                                  ['day']),
                                                          phoneNum: data[
                                                              'phone_number'],
                                                          address:
                                                              data["address"],
                                                          profilePicture: data[
                                                              'profile_picture'],
                                                          email: data['email'],
                                                          governmentID: data[
                                                              'government_id'],
                                                          idNumber:
                                                              data['id_number'],
                                                          account_type:
                                                              data['account_type'],
                                                          verified: data['verified'],
                                                          rejected: data['rejected']));
                                                });
                                          },
                                          child: Text(data["first_name"] +
                                              " " +
                                              data["last_name"]))),
                                  TableCell(child: Text(data["address"])),
                                  TableCell(child: Text(data["phone_number"])),
                                  TableCell(
                                      child: TextButton(
                                          onPressed: () {},
                                          child: Icon(Icons.folder))),
                                  TableCell(
                                      child: Checkbox(
                                    value: data["isActive"] ?? false,
                                    onChanged: (value) {
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(data["email"])
                                          .update({"isActive": value}).then(
                                              (value) {
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Volunteers();
                                        }));
                                      });
                                    },
                                  )),
                                ]);
                              })
                            ],
                          )
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )),
              AdminBottomBar()
            ],
          )),
        ));
  }
}

class UserInfo extends StatefulWidget {
  final UserData data;
  UserInfo({Key? key, required this.data}) : super(key: key);
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  Future<List<DocumentSnapshot>> getUserCertificates() async {
    List<DocumentSnapshot> certificates = [];
    QuerySnapshot user_certificates = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.data.email)
        .collection("certificates")
        .get();
    for (var certificate in user_certificates.docs) {
      var data = certificate.data() as Map;
      var entry = await FirebaseFirestore.instance
          .collection(data['activity_type'])
          .doc(data['activity_id'])
          .get();
      if (entry.exists) {
        certificates.add(entry);
      }
    }
    return certificates;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (widget.data.profilePicture != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.data.profilePicture!),
                    radius: 32,
                  ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Volunteer Data"),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      widget.data.fName + " " + widget.data.lName,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
                child: ListView(
              children: [
                Text("Personal Information",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Text("Birthday"),
                Text(
                  "${widget.data.dob.year}/${widget.data.dob.month}/${widget.data.dob.day}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text("Address"),
                Text(
                  widget.data.address,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text("Phone Number"),
                Text(
                  widget.data.phoneNum,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text("Government ID"),
                Text(
                  widget.data.governmentID + " - " + widget.data.idNumber,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text("Account Type"),
                Text(
                  widget.data.account_type,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text("Nationality"),
                Text(
                  "Filipino",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text("Certificates"),
                FutureBuilder(
                    future: getUserCertificates(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var certificate
                                in snapshot.data as List<DocumentSnapshot>)
                              Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: Text(
                                  (certificate.data() as Map)['name'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    })
              ],
            ))
          ],
        ),
      ),
    );
  }
}
