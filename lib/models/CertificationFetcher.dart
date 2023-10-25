import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_ngo/models/Certification.dart';
import 'package:project_ngo/models/UserSingleton.dart';

class CertificationFetcher {
  UserSingleton user = UserSingleton();

  Future fetch() async {
    List<Future> futures = [];
    List<Certification> certifications = [];

    log("Now processing ${user.user!.certificates.length} certificates");

    for (var certificate in user.user!.certificates) {
      log("reached");
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var entry = await firestore
          .collection(certificate.activity_type)
          .doc(certificate.activity_id)
          .get();
      if (entry.exists) {
        certifications.add(Certification(
            ref: certificate.ref,
            name: entry.data()!['name'],
            rated: entry.data()!['rated'],
            activity_photo: entry.data()!['photo'],
            date: certificate.date,
            photo: certificate.certificate_picture));
      }
    }

    return certifications;
  }
}
