import 'package:cloud_firestore/cloud_firestore.dart';

class Certificate {
  String activity_id;
  String? certificate_picture;
  String activity_type;
  DocumentReference ref;
  final Map<String, dynamic> date;

  Certificate({
    required this.activity_id,
    required this.ref,
    required this.date,
    required this.activity_type,
    this.certificate_picture,
  });
}
