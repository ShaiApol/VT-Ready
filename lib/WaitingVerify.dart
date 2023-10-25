import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/main.dart';

class WaitingVerify extends StatefulWidget {
  @override
  _WaitingVerifyState createState() => _WaitingVerifyState();
}

class _WaitingVerifyState extends State<WaitingVerify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  "Your application is pending.",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ))
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  "We are reviewing your application at the moment. Check back after a few days to see if your application has been accepted.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ))
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  "If you wish to cancel your application, you can request for the deletion of your account details by contacting us at example@example.com. We will delete your account details within 30 days of your request.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ))
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(child: SizedBox.shrink()),
                Text(
                  "- VT Ready Team",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return MainApp();
                    }));
                  });
                },
                child: Text("Log out",
                    style: TextStyle(fontSize: 16, color: Colors.black)))
          ],
        ),
      )),
    );
  }
}
