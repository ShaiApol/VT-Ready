import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_ngo/models/Certificate.dart';

class CertificateFetcher {
  String email;

  CertificateFetcher({required this.email});

  Future<List<Certificate>?> fetch() async {
    List<Certificate> certificates = [];

    var docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('certificates')
        .get();

    for (var doc in docs.docs) {
      certificates.add(Certificate(
          ref: doc.reference,
          activity_id: doc.id,
          activity_type: (doc.data() as Map)['activity_type'],
          date: (doc.data() as Map)['date'],
          certificate_picture:
              (doc.data() as Map)['certificate_picture'] ?? null));
    }

    log("${certificates.length} certificate(s) added");

    return certificates;
  }
}
