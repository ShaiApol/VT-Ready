import 'package:flutter/material.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/utils.dart';

import 'Cards.dart';

class Announcement {
  final String id;
  final String name;
  final String content;
  final Map<String, dynamic>? date;
  final String photo;

  Announcement({
    required this.id,
    required this.name,
    required this.content,
    this.date,
    required this.photo,
  });
}
