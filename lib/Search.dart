import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_ngo/models/UserSingleton.dart';

import 'Message.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  UserSingleton userSingleton = UserSingleton();
  List<QueryDocumentSnapshot> users = [];
  List query_result = [];
  String query = "";

  @override
  void initState() {
    super.initState();
    // fetchUsers();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection("users")
        .where("__name__", isNotEqualTo: userSingleton.user!.email)
        .get()
        .then((value) {
      setState(() {
        users = value.docs;
      });
    });
  }

  void search(String query) {
    var new_result = [];
    for (var user in users) {
      var user_data = (user.data() as Map);
      var email = user_data['email'];
      var full_name = user_data['first_name'] + " " + user_data['last_name'];

      if (query.contains("email:")) {
        if (email.toLowerCase().contains(query.substring(7))) {
          log("${query} matched user ${email}");
          new_result.add(user);
        }
      } else {
        if (full_name.toLowerCase().contains(query.toLowerCase())) {
          log("${query} matched user ${full_name}");
          new_result.add(user);
        }
      }
    }
    setState(() {
      query_result = new_result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF102733),
        title: Container(
          color: Color(0xFF102733),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
                search(value);
              },
              decoration: InputDecoration(
                  hintText: "Search for User",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none)),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
          child: Column(
        children: [
          if (users.isEmpty || query.isEmpty)
            Expanded(
                child: Center(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Begin searching for users by entering their name.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "You can also search for users by their email address instead by adding \"email:\" in the beginning of your query.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                )
              ],
            )))
          else if (query_result.isEmpty)
            Expanded(
                child: Center(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No users found with that name or email.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Make sure your query is correct and without trailing spaces. Add \"email:\" in the beginning of your query to search for users by their email instead.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                )
              ],
            )))
          else
            Expanded(
                child: ListView(
              children: [
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Tap to send the user a message.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8,
                ),
                ...query_result.map((e) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                                height: 120,
                                color: Color(0xFF283F4D),
                                padding: EdgeInsets.all(16),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Message(
                                                  fName: e.data()['first_name'],
                                                  lName: e.data()['last_name'],
                                                  receipient: e.data()['email'],
                                                )));
                                  },
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${e.data()['first_name']} ${e.data()['last_name']}",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "${e.data()['email']}",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "${e.data()['phone_number']}",
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        )),
                                        if (e.data()['photo'] == null)
                                          Icon(
                                            Icons.person,
                                            size: 96,
                                            color: Colors.white,
                                          )
                                        else
                                          Image.network(
                                            e.data()['photo'],
                                            height: 96,
                                          )
                                      ]),
                                )))
                      ],
                    ),
                  );
                })
              ],
            ))
        ],
      )),
    );
  }
}
