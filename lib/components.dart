import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_ngo/Admin/AdminEditProfile.dart';
import 'package:project_ngo/Admin/AdminHome.dart';
import 'package:project_ngo/Admin/AdminOrganizations.dart';
import 'package:project_ngo/models/Organizations.dart';
import 'package:project_ngo/home.dart';
import 'package:project_ngo/main.dart';
import 'package:project_ngo/models/Announcements.dart';

import 'Search.dart';
import 'models/EditProfile.dart';

class TitleText extends StatelessWidget {
  String text;
  TextStyle style;
  Color? color;
  TextAlign align;
  TitleText(
      {super.key,
      this.align = TextAlign.center,
      required this.text,
      this.color,
      this.style = const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)});
  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: align,
        style: color == null
            ? style
            : style.copyWith(
                color: color,
              ));
  }
}

class SmallerTitleText extends StatelessWidget {
  String text;
  TextStyle style;
  Color? color;
  TextAlign align;
  SmallerTitleText(
      {super.key,
      this.align = TextAlign.center,
      required this.text,
      this.color,
      this.style = const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)});
  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: align,
        style: color == null
            ? style
            : style.copyWith(
                color: color,
              ));
  }
}

class SubTitleText extends StatelessWidget {
  String text;
  TextStyle style;
  Color? color;
  TextAlign align;
  SubTitleText(
      {super.key,
      this.align = TextAlign.center,
      required this.text,
      this.color,
      this.style =
          const TextStyle(fontSize: 24, fontWeight: FontWeight.normal)});
  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: align,
        style: color == null
            ? style
            : style.copyWith(
                color: color,
              ));
  }
}

class Body4 extends StatelessWidget {
  String text;
  TextStyle style;
  Color? color;
  TextAlign align;
  Body4(
      {super.key,
      this.align = TextAlign.start,
      required this.text,
      this.color,
      this.style =
          const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)});
  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: align,
        style: color == null
            ? style
            : style.copyWith(
                color: color,
              ));
  }
}

class UpBar extends StatelessWidget {
  Function? setCategoryState;
  UpBar({this.setCategoryState});
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFF112732),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/logo.svg",
                    height: 28,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    "VT",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Ready",
                    style: TextStyle(
                        fontSize: 24,
                        color: Color(0xffFCCD00),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(child: SizedBox.shrink()),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Announcements();
                }));
              },
              child: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 16,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Organizations();
                }));
              },
              child: ImageIcon(
                AssetImage("assets/images/diagram.png"),
                color: Colors.white,
              ),
            )
          ],
        ));
  }
}

class AdminUpBar extends StatelessWidget {
  Function? setCategoryState;
  AdminUpBar({this.setCategoryState});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminHome()));
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/logo.svg",
                    height: 28,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    "VT",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Ready",
                    style: TextStyle(
                        fontSize: 24,
                        color: Color(0xffFCCD00),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(child: SizedBox.shrink()),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Announcements();
                }));
              },
              child: Icon(Icons.notifications),
            ),
            SizedBox(
              width: 16,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AdminOrganizations();
                  }));
                },
                child: ImageIcon(
                  AssetImage("assets/images/diagram.png"),
                  color: Colors.black,
                ))
          ],
        ));
  }
}

class AdminBottomBar extends StatelessWidget {
  Function? setCategoryState;
  AdminBottomBar({this.setCategoryState});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(color: Color(0xFF95D1F3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              if (setCategoryState != null) {
                setCategoryState!("home");
              } else {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminHome()));
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              height: 56,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(48))),
              width: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.house,
                    color: Color(0xFFFFA700),
                    size: 32,
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                        color: Color(0xFFFFA700),
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
            },
            child: Icon(
              Icons.search,
              size: 32,
              color: Colors.black,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminEditProfile()));
            },
            child: Icon(
              Icons.person,
              size: 32,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(color: Color(0xFF152F3E)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Home();
            })),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              height: 56,
              decoration: BoxDecoration(
                  color: Color(0xFF102733),
                  borderRadius: BorderRadius.all(Radius.circular(48))),
              width: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.house,
                    color: Color(0xFFFFA700),
                    size: 32,
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                        color: Color(0xFFFFA700),
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
            },
            child: Icon(
              Icons.search,
              size: 32,
              color: Colors.white,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfile()));
            },
            child: Icon(
              Icons.person,
              size: 32,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class Header3 extends StatelessWidget {
  String text;
  TextStyle style;
  Color? color;
  TextAlign align;
  Header3(
      {super.key,
      this.align = TextAlign.start,
      required this.text,
      this.color,
      this.style = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)});
  @override
  Widget build(BuildContext context) {
    return Text(text,
        overflow: TextOverflow.ellipsis,
        textAlign: align,
        style: color == null
            ? style
            : style.copyWith(
                color: color,
              ));
  }
}

class BoldSubtitleText extends StatelessWidget {
  String text;
  TextStyle style;
  Color? color;
  TextAlign align;
  BoldSubtitleText(
      {super.key,
      this.align = TextAlign.center,
      required this.text,
      this.color,
      this.style = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)});
  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: align,
        style: color == null
            ? style
            : style.copyWith(
                color: color,
              ));
  }
}

class RightArrowBtnText extends StatelessWidget {
  String text;
  TextStyle style;
  Function onPressed;
  Color? color;

  RightArrowBtnText(
      {super.key,
      required this.text,
      required this.onPressed,
      this.color,
      this.style = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: Row(
        children: [
          Text(text,
              style: color == null
                  ? style
                  : style.copyWith(
                      color: color,
                    )),
          SizedBox(width: 10),
          Icon(
            Icons.arrow_forward_ios,
            color: color,
          )
        ],
      ),
    );
  }
}
