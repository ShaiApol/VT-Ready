import 'package:flutter/material.dart';
import 'package:project_ngo/models/UserData.dart';
import 'package:project_ngo/models/UserSingleton.dart';

import '../components.dart';

class RegistrationConfirmation extends StatefulWidget {
  const RegistrationConfirmation({Key? key}) : super(key: key);

  @override
  State<RegistrationConfirmation> createState() =>
      _RegistrationConfirmationState();
}

class _RegistrationConfirmationState extends State<RegistrationConfirmation> {
  UserSingleton userSingleton = UserSingleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF102733),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            BoldSubtitleText(
                text: "Volunteer Event Registration", align: TextAlign.center),
            SizedBox(
              height: 16,
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
                                        child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(userSingleton.user!.fName,
                                          style: TextStyle(fontSize: 16)),
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
                                        child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(userSingleton.user!.lName,
                                          style: TextStyle(fontSize: 16)),
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
                                  SizedBox(
                                    height: 8,
                                  ),
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
                                              Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                    '${userSingleton.user!.dob.month} / ${userSingleton.user!.dob.day} / ${userSingleton.user!.dob.year}',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ))
                                            ],
                                          ),
                                        ),
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
                                  SizedBox(
                                    height: 8,
                                  ),
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
                                              Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                    "+63" +
                                                        userSingleton
                                                            .user!.phoneNum,
                                                    style: TextStyle(
                                                        fontSize: 16)),
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
                                        child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(userSingleton.user!.address,
                                          style: TextStyle(fontSize: 16)),
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
                                        child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(userSingleton.user!.email,
                                          style: TextStyle(fontSize: 16)),
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
                                        child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        userSingleton.user!.governmentID,
                                        style: TextStyle(fontSize: 16),
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
                        Header3(text: "ID Number"),
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
                                        child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        userSingleton.user!.idNumber,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Confirm",
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
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "If these details are incorrect, please go back to the home page and edit your account profile.",
                          textAlign: TextAlign.center,
                        )
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}
