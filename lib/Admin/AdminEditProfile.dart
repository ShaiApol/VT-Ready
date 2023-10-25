import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_ngo/main.dart';
import 'package:project_ngo/models/UserSingleton.dart';

import '../components.dart';
import '../firebase_utils/utils.dart';

class AdminEditProfile extends StatefulWidget {
  @override
  _AdminEditProfileState createState() => _AdminEditProfileState();
}

class _AdminEditProfileState extends State<AdminEditProfile> {
  UserSingleton userSingleton = UserSingleton();

  XFile? newProfilePicture;

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
  TextEditingController currentPasswordController = TextEditingController();

  String passwordText = "";

  bool currentPasswordValid = true;
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
  void initState() {
    month = userSingleton.user!.dob.month;
    day = userSingleton.user!.dob.day;
    year = userSingleton.user!.dob.year;
    selectedDate = DateTime(int.parse(year!), int.parse(month!),
        int.parse(day!)); //DateTime(1990, 1, 1
    fNameController.text = userSingleton.user!.fName;
    lNameController.text = userSingleton.user!.lName;
    phoneNumController.text = userSingleton.user!.phoneNum;
    addressController.text = userSingleton.user!.address;
    emailController.text = userSingleton.user!.email;
    idNumberController.text = userSingleton.user!.idNumber;
    selectedDocument = userSingleton.user!.governmentID;
    super.initState();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Expanded(child: SizedBox.shrink()),
                ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return MainApp();
                        }), (route) => false);
                      });
                    },
                    child: Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white)),
              child: ListView(
                children: [
                  GestureDetector(
                      onTap: () async {
                        XFile? file = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (file != null) {
                          setState(() {
                            newProfilePicture = file;
                            userSingleton.user!.profilePicture =
                                newProfilePicture!.path;
                          });
                        }
                      },
                      child: Row(
                        children: [
                          if (newProfilePicture == null)
                            if (userSingleton.user!.profilePicture != null)
                              CircleAvatar(
                                radius: 36,
                                backgroundImage: NetworkImage(userSingleton
                                    .user!.profilePicture
                                    .toString()),
                              )
                            else
                              Icon(
                                Icons.person,
                                size: 48,
                              )
                          else
                            CircleAvatar(
                              radius: 36,
                              backgroundImage:
                                  FileImage(File(newProfilePicture!.path)),
                            ),
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Click here to edit"),
                              Text(
                                "Profile Picture",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      )),
                  SizedBox(height: 15),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  child: Text('$month / $day / $year'),
                                )),
                              ],
                            )
                          ])),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xFF28404F),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
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
                  Header3(text: "Password"),
                  Text("Leave empty to keep current password"),
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
                                onChanged: (value) {
                                  setState(() {
                                    passwordText = value;
                                  });
                                },
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
                  if (passwordText.isNotEmpty) ...[
                    SizedBox(
                      height: 16,
                    ),
                    Header3(text: "Current Password"),
                    SizedBox(
                      height: 8,
                    ),
                    if (!currentPasswordValid) ...[
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
                                  controller: currentPasswordController,
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
                  ],
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
                                ].map<DropdownMenuItem<String>>((String value) {
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

                          if (passwordText.isNotEmpty) {
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

                            if (!RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[?!@#\$&*~]).{8,}$')
                                .hasMatch(currentPasswordController.text)) {
                              no_errors = false;
                              setState(() {
                                passwordValid = false;
                              });
                            } else {
                              setState(() {
                                passwordValid = true;
                              });
                            }

                            if (currentPasswordValid && passwordValid) {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: userSingleton.user!.email,
                                      password: currentPasswordController.text)
                                  .then((value) {
                                value.user!
                                    .updatePassword(passwordController.text);
                              });
                            }
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

                          if (no_errors) {
                            FirebaseFirestore firestore = FirebaseFirestore
                                .instance; //Get instance of firestore
                            CollectionReference users = firestore.collection(
                                'users'); //Get reference to users collection
                            var checkUser =
                                await users.doc(emailController.text).get();
                            if (!checkUser.exists) {
                              //User does not exist
                            } else {
                              await users.doc(emailController.text).update({
                                'account_type': "user",
                                'first_name': fNameController.text,
                                'last_name': lNameController.text,
                                'date_of_birth': serializeDateTimeToDateofBirth(
                                    selectedDate!),
                                'phone_number': phoneNumController.text,
                                'address': addressController.text,
                                'email': emailController.text,
                                'government_id': selectedDocument,
                                'id_number': idNumberController.text,
                              }).then((value) {
                                if (newProfilePicture != null) {
                                  FirebaseStorage storage =
                                      FirebaseStorage.instance;

                                  storage
                                      .ref(userSingleton.user!.email)
                                      .putFile(File(newProfilePicture!.path))
                                      .then((p0) {
                                    p0.ref.getDownloadURL().then((value) {
                                      users
                                          .doc(userSingleton.user!.email)
                                          .update({'profile_picture': value});
                                    });
                                  });
                                }
                              }).then((value) {
                                Navigator.push((context),
                                    MaterialPageRoute(builder: (context) {
                                  return MainApp();
                                }));
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
                                "Update",
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
              ),
            ),
          )),
        ],
      )),
    );
  }
}
