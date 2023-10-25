import 'package:flutter/material.dart';
import 'package:project_ngo/models/UserData.dart';

class UserSingleton {
  static final UserSingleton _singleton = UserSingleton._internal();

  factory UserSingleton() {
    return _singleton;
  }

  UserSingleton._internal();

  UserData? user;
  Image? profilePicture;
  DateTime dateNow = DateTime.now();

  void setProfilePicture(String? path) {
    if (path != null) {
      profilePicture = Image.network(path);
    }
  }
}
