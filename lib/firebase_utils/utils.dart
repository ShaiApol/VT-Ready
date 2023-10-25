import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_ngo/models/UserData.dart';

import '../models/DateOfBirth.dart';

Future<UserData?> retrieveUserFromFirebase(String email) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot<Map<String, dynamic>> userDoc =
      await firestore.collection('users').doc(email).get();

  if (userDoc.exists) {
    Map<String, dynamic> userData = userDoc.data()!;
    UserData model = UserData(
      account_type: (userData['account_type'] == "admin" ? 'admin' : 'user'),
      fName: userData['first_name'],
      lName: userData['last_name'],
      dob: DateOfBirth(
        year: userData['date_of_birth']['year'],
        month: userData['date_of_birth']['month'],
        day: userData['date_of_birth']['day'],
      ),
      phoneNum: userData['phone_number'],
      address: userData['address'],
      profilePicture: userData['profile_picture'],
      email: userData['email'],
      governmentID: userData['government_id'],
      idNumber: userData['id_number'],
      registered_activities: userData['registered_activities'] ?? null,
      verified: userData['verified'],
      rejected: userData['rejected'],
    );
    return model;
  }
  return null;
}

Future<String?> retrieveProfilePictureFromStorage(String email) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  DocumentSnapshot<Map<String, dynamic>> userDoc =
      await firestore.collection('users').doc(email).get();

  if (userDoc.exists) {
    Map<String, dynamic> userData = userDoc.data()!;
    try {
      return await storage.ref(userData['email']).getDownloadURL();
    } catch (e) {
      return null;
    }
  }
  return null;
}

serializeDateTimeToDateofBirth(DateTime date, {bool number = false}) {
  if (number) {
    return {
      'year': date.year,
      'month': date.month,
      'day': date.day,
    };
  } else {
    return {
      'year': date.year.toString(),
      'month': date.month.toString(),
      'day': date.day.toString(),
    };
  }
}
