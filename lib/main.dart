import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/firebase_utils/utils.dart';
import 'package:project_ngo/models/CertificateFetcher.dart';
import 'package:project_ngo/models/CertificationFetcher.dart';
import 'package:project_ngo/models/UserSingleton.dart';

import 'package:project_ngo/Admin/AdminHome.dart';
import 'Login.dart';
import 'Rejected.dart';
import 'WaitingVerify.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'models/DateOfBirth.dart';
import 'models/UserData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    theme: ThemeData(
        primaryColor: const Color(
            0xFFFDCD01), // Primary color for app bars, buttons, etc.
        highlightColor: const Color(
            0xFFFDCD01), // Highlight color for text fields, buttons, etc.
        scaffoldBackgroundColor:
            const Color(0xFF112732), // Background color for all pages
        textTheme: TextTheme(
            bodyLarge: TextStyle(
                color: Colors.white), // Set the default text color to white
            bodyMedium: TextStyle(color: Colors.white),
            bodySmall: TextStyle(
                color: Colors.white), // Set the default text color to white
            titleMedium: TextStyle(color: Colors.white)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color(0xFFFDCD01)), // Set the color of the ElevatedButton
          ),
        )
        // You can customize more theme properties here if needed
        ),
    home: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await retrieveUserFromFirebase(user.email!).then((value) async {
          if (value != null) {
            if (value.verified) {
              UserSingleton userSingleton = UserSingleton();
              userSingleton.user = value;
              userSingleton.setProfilePicture(value.profilePicture);
              if (userSingleton.user!.account_type == "user") {
                CertificateFetcher fetcher =
                    CertificateFetcher(email: user.email!);

                await fetcher.fetch().then((value) {
                  if (value != null) {
                    log("Certificates added to User Singleton");
                    userSingleton.user!.certificates = value;
                  }
                });

                Navigator.pushReplacement((context),
                    MaterialPageRoute(builder: (context) {
                  return Home();
                }));
              } else {
                Navigator.pushReplacement((context),
                    MaterialPageRoute(builder: (context) {
                  return AdminHome();
                }));
              }
            } else if (value.rejected) {
              Navigator.pushReplacement((context),
                  MaterialPageRoute(builder: (context) {
                return Rejected();
              }));
            } else if (!value.verified) {
              Navigator.pushReplacement((context),
                  MaterialPageRoute(builder: (context) {
                return WaitingVerify();
              }));
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/getting_started.png"),
              fit: BoxFit.cover)),
      child: Column(
        children: [
          Expanded(child: SizedBox.shrink()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "VT",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFDCD01)),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Ready",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                SubTitleText(
                    align: TextAlign.left,
                    text:
                        "Volunteers and Training Information System for NGOs for Disaster Management."),
                SizedBox(
                  height: 16,
                ),
                RightArrowBtnText(
                  text: "Get Started",
                  onPressed: () {
                    Navigator.push((context),
                        MaterialPageRoute(builder: (context) {
                      return RegistrationWidget();
                    }));
                  },
                  color: Colors.white,
                )
              ],
            ),
          ),
          Expanded(child: SizedBox.shrink()),
        ],
      ),
    ));
  }
}

class RegistrationWidget extends StatefulWidget {
  const RegistrationWidget({Key? key}) : super(key: key);

  @override
  State<RegistrationWidget> createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  DateTime? selectedDate;
  String? month;
  String? day;
  String? year;
  String? selectedDocument;

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController experiencesController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController referralController = TextEditingController();

  bool fNameValid = true;
  bool lNameValid = true;
  bool dobValid = true;
  bool phoneNumValid = true;
  bool addressValid = true;
  bool passwordValid = true;
  bool emailValid = true;
  bool governmentIDValid = true;
  bool idNumberValid = true;
  bool skillsValid = true;
  bool experiencesValid = true;
  bool reasonValid = true;
  bool referralValid = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.amberAccent, // <-- SEE HERE
              onPrimary: Colors.black, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textTheme: Typography.blackCupertino,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        month = picked.month.toString();
        day = picked.day.toString();
        year = picked.year.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                SmallerTitleText(
                  text: "VT",
                  color: Colors.amberAccent,
                ),
                SizedBox(
                  width: 8,
                ),
                SmallerTitleText(text: "Ready")
              ],
            ),
            SizedBox(
              height: 32,
            ),
            BoldSubtitleText(
                text: "Create an Account", align: TextAlign.center),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                SizedBox(
                  width: 8,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement((context),
                          MaterialPageRoute(builder: (context) {
                        return Login();
                      }));
                    },
                    child: Text("Sign In"))
              ],
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white)),
                    child: ListView(
                      children: [
                        Header3(text: "First Name"),
                        SizedBox(
                          height: 8,
                        ),
                        if (!fNameValid) ...[
                          Row(children: [
                            Expanded(
                                child: Text(
                              "First name is required",
                              style: TextStyle(color: Colors.red),
                            ))
                          ]),
                          SizedBox(
                            height: 8,
                          )
                        ],
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF28404F),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      controller: fNameController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Header3(text: "Last Name"),
                        SizedBox(
                          height: 8,
                        ),
                        if (!lNameValid) ...[
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Last name is required",
                              style: TextStyle(color: Colors.red),
                            ))
                          ]),
                          SizedBox(
                            height: 8,
                          )
                        ],
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF28404F),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      controller: lNameController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Header3(text: "Date of Birth"),
                                  if (!dobValid) ...[
                                    Row(children: [
                                      Expanded(
                                          child: Text(
                                        "Select your date of birth",
                                        style: TextStyle(color: Colors.red),
                                      ))
                                    ]),
                                    SizedBox(
                                      height: 8,
                                    )
                                  ],
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color(0xFFFDCD01)),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black),
                                        ),
                                        onPressed: () => _selectDate(context),
                                        child: Text(selectedDate != null
                                            ? '$month / $day / $year'
                                            : '01/01/1990'),
                                      )),
                                    ],
                                  )
                                ])),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Header3(text: "Phone Number"),
                                  if (!phoneNumValid) ...[
                                    Row(children: [
                                      Expanded(
                                          child: Text(
                                        "Input a valid phone number",
                                        style: TextStyle(color: Colors.red),
                                      ))
                                    ]),
                                    SizedBox(
                                      height: 8,
                                    )
                                  ],
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Color(0xFF28404F),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Row(
                                            children: [
                                              Text("+63"),
                                              Expanded(
                                                  child: TextFormField(
                                                controller: phoneNumController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                      )),
                                    ],
                                  )
                                ])),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Header3(text: "Address"),
                        SizedBox(
                          height: 8,
                        ),
                        if (!addressValid) ...[
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Address is required",
                              style: TextStyle(color: Colors.red),
                            ))
                          ]),
                          SizedBox(
                            height: 8,
                          )
                        ],
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF28404F),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      controller: addressController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Header3(text: "Email"),
                        SizedBox(
                          height: 8,
                        ),
                        if (!emailValid) ...[
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Input a valid email address",
                              style: TextStyle(color: Colors.red),
                            ))
                          ]),
                          SizedBox(
                            height: 8,
                          )
                        ],
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF28404F),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Header3(text: "Password"),
                        SizedBox(
                          height: 8,
                        ),
                        if (!passwordValid) ...[
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Password must be at least 8 characters, have one uppercase and lower case letter, a special character, and one number",
                              style: TextStyle(color: Colors.red),
                            ))
                          ]),
                          SizedBox(
                            height: 8,
                          )
                        ],
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF28404F),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      controller: passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Header3(text: "Government ID"),
                        SizedBox(
                          height: 8,
                        ),
                        if (!governmentIDValid) ...[
                          Row(children: [
                            Expanded(
                                child: Text(
                              "Select a valid government ID",
                              style: TextStyle(color: Colors.red),
                            ))
                          ]),
                          SizedBox(
                            height: 8,
                          )
                        ],
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF28404F),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: DropdownButton<String>(
                                      underline: Container(),
                                      isExpanded: true,
                                      value: selectedDocument,
                                      hint: Text(
                                        'Select Government ID',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      dropdownColor: Color(0xFF28404F),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedDocument = newValue;
                                        });
                                      },
                                      items: <String>[
                                        'Passport',
                                        'PRC ID',
                                        "Driver's License",
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ))
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Header3(text: "ID Number"),
                        SizedBox(
                          height: 8,
                        ),
                        if (!idNumberValid) ...[
                          if (!governmentIDValid) ...[
                            Row(children: [
                              Expanded(
                                  child: Text(
                                "Select a valid government ID then enter your ID number",
                                style: TextStyle(color: Colors.red),
                              ))
                            ]),
                          ] else ...[
                            Row(children: [
                              Expanded(
                                  child: Text(
                                "Enter your ID number",
                                style: TextStyle(color: Colors.red),
                              ))
                            ])
                          ],
                          SizedBox(
                            height: 8,
                          )
                        ],
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF28404F),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      controller: idNumberController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Header3(text: "Skills"),
                        if (!addressValid) ...[
                          Row(children: [
                            Expanded(
                                child: Text(
                              "This field is required",
                              style: TextStyle(color: Colors.red),
                            ))
                          ]),
                          SizedBox(
                            height: 8,
                          )
                        ],
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF28404F),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      maxLines: 4,
                                      controller: skillsController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Header3(text: "Experiences Relevant to Volunteering"),
                        SizedBox(
                          height: 8,
                        ),
                        if (!experiencesValid) ...[
                          Row(children: [
                            Expanded(
                                child: Text(
                              "This field is required",
                              style: TextStyle(color: Colors.red),
                            ))
                          ]),
                          SizedBox(
                            height: 8,
                          )
                        ],
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF28404F),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      maxLines: 4,
                                      controller: experiencesController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Header3(text: "Reason for Volunteering"),
                        if (!reasonValid) ...[
                          Row(children: [
                            Expanded(
                                child: Text(
                              "This field is required",
                              style: TextStyle(color: Colors.red),
                            ))
                          ]),
                          SizedBox(
                            height: 8,
                          )
                        ],
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF28404F),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      maxLines: 4,
                                      controller: reasonController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Header3(text: "How did you hear about VT Ready?"),
                        if (!referralValid) ...[
                          Row(children: [
                            Expanded(
                                child: Text(
                              "This field is required",
                              style: TextStyle(color: Colors.red),
                            ))
                          ]),
                          SizedBox(
                            height: 8,
                          )
                        ],
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF28404F),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      maxLines: 2,
                                      controller: referralController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ElevatedButton(
                              onPressed: () async {
                                bool no_errors = true;
                                if (fNameController.text.isEmpty) {
                                  no_errors = false;
                                  setState(() {
                                    fNameValid = false;
                                  });
                                } else {
                                  setState(() {
                                    fNameValid = true;
                                  });
                                }

                                if (lNameController.text.isEmpty) {
                                  no_errors = false;
                                  setState(() {
                                    lNameValid = false;
                                  });
                                } else {
                                  setState(() {
                                    lNameValid = true;
                                  });
                                }

                                if (selectedDate == null) {
                                  no_errors = false;
                                  setState(() {
                                    dobValid = false;
                                  });
                                } else {
                                  setState(() {
                                    dobValid = true;
                                  });
                                }

                                if (phoneNumController.text.isEmpty) {
                                  no_errors = false;
                                  setState(() {
                                    phoneNumValid = false;
                                  });
                                } else {
                                  setState(() {
                                    phoneNumValid = true;
                                  });
                                }

                                if (addressController.text.isEmpty) {
                                  no_errors = false;
                                  setState(() {
                                    addressValid = false;
                                  });
                                } else {
                                  setState(() {
                                    addressValid = true;
                                  });
                                }

                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(emailController.text)) {
                                  no_errors = false;
                                  setState(() {
                                    emailValid = false;
                                  });
                                } else {
                                  setState(() {
                                    emailValid = true;
                                  });
                                }
                                //The password should be 8 chars long, have one upper and lowercase character, a number, and a special character.
                                if (!RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[?!@#\$&*~]).{8,}$')
                                    .hasMatch(passwordController.text)) {
                                  no_errors = false;
                                  setState(() {
                                    passwordValid = false;
                                  });
                                } else {
                                  setState(() {
                                    passwordValid = true;
                                  });
                                }

                                if (selectedDocument == null) {
                                  no_errors = false;
                                  setState(() {
                                    governmentIDValid = false;
                                  });
                                } else {
                                  setState(() {
                                    governmentIDValid = true;
                                  });
                                }

                                if (idNumberController.text.isEmpty) {
                                  no_errors = false;
                                  setState(() {
                                    idNumberValid = false;
                                  });
                                } else {
                                  setState(() {
                                    idNumberValid = true;
                                  });
                                }

                                if (skillsController.text.isEmpty) {
                                  no_errors = false;
                                  setState(() {
                                    skillsValid = false;
                                  });
                                } else {
                                  setState(() {
                                    skillsValid = true;
                                  });
                                }

                                if (experiencesController.text.isEmpty) {
                                  no_errors = false;
                                  setState(() {
                                    experiencesValid = false;
                                  });
                                } else {
                                  setState(() {
                                    experiencesValid = true;
                                  });
                                }

                                if (reasonController.text.isEmpty) {
                                  no_errors = false;
                                  setState(() {
                                    reasonValid = false;
                                  });
                                } else {
                                  setState(() {
                                    reasonValid = true;
                                  });
                                }

                                if (referralController.text.isEmpty) {
                                  no_errors = false;
                                  setState(() {
                                    referralValid = false;
                                  });
                                } else {
                                  setState(() {
                                    referralValid = true;
                                  });
                                }

                                if (no_errors) {
                                  FirebaseFirestore firestore =
                                      FirebaseFirestore
                                          .instance; //Get instance of firestore
                                  CollectionReference users = firestore.collection(
                                      'users'); //Get reference to users collection
                                  var checkUser = await users
                                      .doc(emailController.text)
                                      .get();
                                  if (checkUser.exists) {
                                    //User already exists
                                  } else {
                                    //User does not exist
                                    users.doc(emailController.text).set({
                                      'account_type': "user",
                                      'first_name': fNameController.text,
                                      'last_name': lNameController.text,
                                      'date_of_birth':
                                          serializeDateTimeToDateofBirth(
                                              selectedDate!),
                                      'phone_number': phoneNumController.text,
                                      'address': addressController.text,
                                      'email': emailController.text,
                                      'government_id': selectedDocument,
                                      'id_number': idNumberController.text,
                                      'verified': false,
                                      'rejected': false,
                                    });

                                    FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: emailController.text,
                                            password: passwordController.text)
                                        .then((value) {
                                      if (value.user != null) {
                                        value.user!.updateDisplayName(
                                            fNameController.text);
                                        UserSingleton _userSingleton =
                                            UserSingleton();

                                        _userSingleton.user = UserData(
                                          account_type: "user",
                                          fName: fNameController.text,
                                          lName: lNameController.text,
                                          dob: DateOfBirth(
                                            year: year!,
                                            month: month!,
                                            day: day!,
                                          ),
                                          phoneNum: phoneNumController.text,
                                          address: addressController.text,
                                          email: emailController.text,
                                          governmentID: selectedDocument!,
                                          idNumber: idNumberController.text,
                                          verified: false,
                                          rejected: false,
                                        );
                                        Navigator.push((context),
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return MainApp();
                                        }));
                                      }
                                    });
                                  }
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Register",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ))
                          ],
                        )
                      ],
                    ))),
          ],
        ),
      )),
    );
  }
}
