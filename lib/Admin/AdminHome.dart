import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_ngo/Admin/AdminHomeTabManager.dart';
import 'package:project_ngo/Admin/EditTrainingMaterials.dart';
import 'package:project_ngo/Admin/ManageEvents.dart';
import 'package:project_ngo/Admin/ManageTrainings.dart';
import 'package:project_ngo/Admin/ManageRewards.dart';
import 'package:project_ngo/models/UserSingleton.dart';

import 'package:project_ngo/components.dart';
import 'package:project_ngo/home.dart';

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

class AdminHome extends StatefulWidget {
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String state = "home";
  UserSingleton userSingleton = UserSingleton();
  void setCategoryState(String category) {
    setState(() {
      state = category;
    });
  }

  @override
  void initState() {
    var locPerms = Permission.location.request().then((locPerms) async {
      if (locPerms.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        FirebaseFirestore.instance
            .collection("users")
            .doc(userSingleton.user!.email)
            .update({"location": "${position.latitude},${position.longitude}"});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AdminTheme,
        child: Scaffold(
          body: SafeArea(
            child: Container(
              child: Column(
                children: [
                  AdminUpBar(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SubTitleText(
                                      text:
                                          "Hello, ${userSingleton.user!.fName}!"),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Body4(
                                      text:
                                          "Let's explore what's happening nearby")
                                ],
                              ),
                            ),
                            if (userSingleton.profilePicture != null)
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(
                                    userSingleton.user!.profilePicture!),
                              )
                            else
                              Icon(
                                Icons.person,
                                color: Colors.black,
                                size: 48,
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        DateWidget(),
                        SizedBox(
                          height: 24,
                        ),
                        CategoryFilter(setCategoryState: setCategoryState),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                  AdminHomeTabManager(
                    state: state,
                    email: userSingleton.user!.email,
                  ),
                  AdminBottomBar(setCategoryState: setCategoryState)
                ],
              ),
            ),
          ),
        ));
  }
}

class CategoryFilter extends StatefulWidget {
  Function(String) setCategoryState;
  CategoryFilter({required this.setCategoryState});
  @override
  State<StatefulWidget> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0x2354BCF8),
      ),
      height: 84,
      padding: EdgeInsets.all(12),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                widget.setCategoryState("trainings");
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ImageIcon(
                      AssetImage("assets/images/training_black.png"),
                      size: 32,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text("Training"),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                widget.setCategoryState("events");
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.celebration,
                      color: Colors.black,
                      size: 32,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text("Events"),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                widget.setCategoryState("calendar");
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Colors.black,
                      size: 32,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text("Calendar"),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                widget.setCategoryState("messages");
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.message,
                      color: Colors.black,
                      size: 32,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text("Messages"),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                widget.setCategoryState("rewards");
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.black,
                      size: 32,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text("Rewards"),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
