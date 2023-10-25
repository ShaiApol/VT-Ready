import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/Admin/AdminHome.dart';
import 'package:project_ngo/Admin/OrgMessage.dart';
import 'package:project_ngo/Message.dart';
import 'package:project_ngo/components.dart';

class Organizations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrganizationsState();
}

class _OrganizationsState extends State<Organizations> {
  bool loading = true;
  List<Widget> organizations = [];
  Future<void> getOrganizations() async {
    var firestore = FirebaseFirestore.instance;
    var organizationsFS = await firestore.collection("organizations").get();
    List<Widget> newOrganizations = [];

    for (var organization in organizationsFS.docs) {
      List<Widget> members = [];
      for (var member in organization.data()['members']) {
        var member_doc =
            await firestore.collection("users").doc(member['email']).get();
        members.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            onTap: () {
              if (member['email'] != FirebaseAuth.instance.currentUser!.email) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return OrgMessage(
                      role: member['role'],
                      receipient: member['email'],
                      fName: member_doc.data()!['first_name'],
                      lName: member_doc.data()!['last_name']);
                }));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black)),
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  if (member_doc.data()!['profile_picture'] != null &&
                      member_doc.data()!['profile_picture'] != "")
                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          NetworkImage(member_doc.data()!['profile_picture']!),
                    )
                  else
                    Icon(
                      Icons.person,
                      size: 48,
                    ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member_doc.data()!['first_name'] +
                            " " +
                            member_doc.data()!['last_name'],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        member['role'],
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ));
      }
      newOrganizations.add(Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          height: 260,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(organization.data()['name']),
              ),
              Expanded(
                  child: Column(
                children:
                    members.sublist(0, members.length > 2 ? 2 : members.length),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: ListView(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        children: members),
                                  );
                                });
                          },
                          child: Text("View All"))),
                  SizedBox(
                    width: 16,
                  ),
                ],
              )
            ],
          ),
        ),
      ));
    }

    setState(() {
      organizations = newOrganizations;
    });
  }

  @override
  void initState() {
    getOrganizations().then((_) {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AdminTheme,
        child: Scaffold(
            backgroundColor: Colors.grey[200],
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: UpBar(),
                  ),
                  if (organizations.isNotEmpty) ...[
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: ListView(children: organizations),
                    )),
                  ] else
                    Expanded(
                        child: Center(
                            child: Text(loading
                                ? "Loading your Organizations..."
                                : "You have no organizations to display"))),
                  BottomBar()
                ],
              ),
            )));
  }
}

class CreateNewOrganizationModal extends StatefulWidget {
  Function refresh;
  CreateNewOrganizationModal({required this.refresh});
  @override
  State<StatefulWidget> createState() => _CreateNewOrganizationModalState();
}

class _CreateNewOrganizationModalState
    extends State<CreateNewOrganizationModal> {
  TextEditingController nameController = TextEditingController();
  TextEditingController membersController = TextEditingController();
  List<Map> members = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Create a new Organization",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(
            height: 16,
          ),
          TextField(
            style: TextStyle(color: Colors.black),
            controller: nameController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Organization Name"),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: ListView(
              children: members.map((e) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black)),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      if (e['profile_picture'] != null &&
                          e['profile_picture'] != "")
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(e['profile_picture']!),
                        )
                      else
                        Icon(
                          Icons.person,
                          size: 48,
                        ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e['full_name'],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            e['role'],
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ))
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Row(children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SearchUser(addMember: (String email,
                                String full_name,
                                String role,
                                String? profile_picture) {
                              setState(() {
                                members.add({
                                  "email": email,
                                  "role": role,
                                  "full_name": full_name,
                                  "profile_picture": profile_picture
                                });
                              });
                            });
                          });
                    },
                    child: Text("Add a Member")))
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && members.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection("organizations")
                          .add({
                        "name": nameController.text,
                        "members": members.map((e) {
                          return {"email": e['email'], "role": e['role']};
                        }).toList()
                      }).then((value) {
                        widget.refresh().then((_) {
                          Navigator.pop(context);
                        });
                      });
                    }
                  },
                  child: Text("Create"))
            ],
          )
        ],
      ),
    );
  }
}

class SearchUser extends StatefulWidget {
  Function(String email, String full_name, String role, String? profile_picture)
      addMember;

  SearchUser({required this.addMember});
  @override
  State<StatefulWidget> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  List allUsers = [];
  List matchedUsers = [];
  bool loading = true;

  Future<List> getAllUsers() async {
    var users = await FirebaseFirestore.instance.collection("users").get();
    return users.docs;
  }

  @override
  void initState() {
    getAllUsers().then((users) {
      setState(() {
        allUsers = users;
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          if (loading)
            Expanded(
                child: Center(
              child: CircularProgressIndicator(),
            ))
          else ...[
            TextField(
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                setState(() {
                  matchedUsers = allUsers
                      .where((user) =>
                          user
                              .data()['email']
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          user
                              .data()['first_name']
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          user
                              .data()['last_name']
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                      .toList();
                });
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Name"),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
                child: ListView(
              children: [
                ...matchedUsers.map((e) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () async {
                        String role = await showModalBottomSheet(
                            isScrollControlled: false,
                            context: context,
                            builder: (context) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "What is ${e.data()!['first_name']}'s Role?",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        TextFormField(
                                          style: TextStyle(color: Colors.black),
                                          onFieldSubmitted: (value) {
                                            if (value != "") {
                                              Navigator.pop(context, value);
                                            }
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Role"),
                                        ),
                                      ],
                                    ),
                                  ));
                            });
                        if (role != "") {
                          widget.addMember(
                              e.data()!['email'],
                              "${e.data()!['first_name']} ${e.data()!['last_name']}",
                              role,
                              e.data()!['profile_picture']);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black)),
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            if (e.data()!['profile_picture'] != null &&
                                e.data()!['profile_picture'] != "")
                              CircleAvatar(
                                radius: 24,
                                backgroundImage:
                                    NetworkImage(e.data()!['profile_picture']!),
                              )
                            else
                              Icon(
                                Icons.person,
                                size: 48,
                              ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.data()!['first_name'] +
                                      " " +
                                      e.data()!['last_name'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                  );
                })
              ],
            ))
          ]
        ],
      ),
    );
  }
}
