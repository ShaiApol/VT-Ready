import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_ngo/models/DateOfBirth.dart';

import 'Certificate.dart';

class UserData {
  String fName;
  String lName;
  DateOfBirth dob;
  String phoneNum;
  String address;
  String email;
  String governmentID;
  String idNumber;
  String? profilePicture;
  List<String>? registered_activities;
  List<Certificate> certificates = [];
  String account_type;
  bool verified;
  bool rejected;

  UserData(
      {required this.fName,
      required this.lName,
      required this.dob,
      required this.phoneNum,
      required this.address,
      required this.email,
      required this.governmentID,
      required this.idNumber,
      required this.account_type,
      required this.verified,
      required this.rejected,
      this.profilePicture,
      this.registered_activities});

  Map<String, dynamic> serializeIntoMap() {
    return {
      'fName': fName,
      'lName': lName,
      'dob': {
        'year': dob.year,
        'month': dob.month,
        'day': dob.day,
      },
      'phoneNum': phoneNum,
      'address': address,
      'email': email,
      'governmentID': governmentID,
      'idNumber': idNumber,
      'account_type': account_type,
      'profile_picture': profilePicture
    };
  }

  void uploadToFirebase() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .set(serializeIntoMap());
  }
}
