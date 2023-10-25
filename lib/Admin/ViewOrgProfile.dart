import 'package:flutter/material.dart';
import 'package:project_ngo/Admin/AdminHome.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/models/Organizations.dart';
import 'package:project_ngo/models/UserSingleton.dart';

class ViewOrgProfile extends StatelessWidget {
  final Map userToView;
  final String role;
  final List trainings;
  final List<Map> certificates;
  ViewOrgProfile(
      {Key? key,
      required this.certificates,
      required this.trainings,
      required this.userToView,
      required this.role})
      : super(key: key);
  UserSingleton userSingleton = UserSingleton();
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AdminTheme,
        child: Scaffold(
          body: SafeArea(
            child: Column(children: [
              if (userSingleton.user!.account_type == "admin")
                AdminUpBar()
              else
                UpBar(),
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back),
                    ),
                    SizedBox(width: 16),
                    Text(
                      "${userToView['first_name']} ${userToView['last_name']}",
                      style: TextStyle(fontSize: 28),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (userToView['profile_picture'] != null &&
                        userToView['profile_picture'] != "")
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            NetworkImage(userToView['profile_picture']),
                      ),
                    SizedBox(height: 12),
                    Text(
                      role,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: SizedBox.shrink()),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.chat_outlined),
                        ),
                        SizedBox(width: 24),
                        Icon(Icons.person_2_outlined),
                        SizedBox(width: 24),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Organizations())),
                          child: ImageIcon(
                              AssetImage("assets/images/diagram.png")),
                        ),
                        Expanded(child: SizedBox.shrink())
                      ],
                    ),
                    SizedBox(height: 24),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              SizedBox(
                                width: 12,
                              ),
                              Text(userToView['email'],
                                  style: TextStyle(fontSize: 16))
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Contact Number",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              SizedBox(
                                width: 12,
                              ),
                              Text(userToView['phone'] ?? "Not Provided",
                                  style: TextStyle(fontSize: 16))
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Expanded(
                        child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Trainings Attended",
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(height: 8),
                          ...trainings.map((e) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Text(e['name'])
                              ],
                            );
                          })
                        ],
                      ),
                    )),
                    Expanded(
                        child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Certificates",
                                style: TextStyle(fontSize: 20),
                              )),
                          SizedBox(height: 8),
                          ...certificates.map((e) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            child:
                                                Image.network(e['certificate']),
                                          );
                                        });
                                  },
                                  child: Text(e['name']),
                                )
                              ],
                            );
                          })
                        ],
                      ),
                    ))
                  ],
                ),
              )),
              if (userSingleton.user!.account_type == "admin")
                AdminBottomBar()
              else
                BottomBar()
            ]),
          ),
        ));
  }
}
