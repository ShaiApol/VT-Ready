import 'dart:typed_data';

import 'package:http/http.dart' as http;

class CertificateGenerator {
  String name, training_name, day, month, year;

  CertificateGenerator(
      {required this.training_name,
      required this.name,
      required this.day,
      required this.month,
      required this.year});

  Future<Uint8List> generateImage() async {
    //This will fetch the image from an API
    print(
        "Attempting to generate a certificate in https://api.vtavxsrv.pro/generateCertificate?name=${name}&training_name=${training_name}&day=${day}&month=${month}&year=${year}");
    var res = await http.get(Uri.parse(
        'https://api.vtavxsrv.pro/generateCertificate?name=${name}&training_name=${training_name}&day=${day}&month=${month}&year=${year}'));

    return res.bodyBytes;
  }
}
