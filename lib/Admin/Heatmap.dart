import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:project_ngo/Admin/AdminHome.dart';
import 'package:project_ngo/components.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/UserSingleton.dart';

class Heatmap extends StatefulWidget {
  @override
  HeatmapState createState() => HeatmapState();
}

class HeatmapState extends State<Heatmap> {
  UserSingleton userSingleton = UserSingleton();
  bool isReady = false;
  String users = "";

  @override
  void initState() {
    getAllUsers().then((value) {
      setState(() {
        users = value;
        isReady = true;
      });
    });
    super.initState();
  }

  // WebViewController controller = WebViewController()
  //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //   ..setBackgroundColor(const Color(0x00000000))
  //   ..setNavigationDelegate(
  //     NavigationDelegate(
  //       onProgress: (int progress) {
  //         // Update loading bar.
  //       },
  //       onPageStarted: (String url) {},
  //       onPageFinished: (String url) {},
  //       onWebResourceError: (WebResourceError error) {},
  //       onNavigationRequest: (NavigationRequest request) {
  //         if (request.url.startsWith('https://www.youtube.com/')) {
  //           return NavigationDecision.prevent;
  //         }
  //         return NavigationDecision.navigate;
  //       },
  //     ),
  //   )
  //   ..loadRequest(Uri.parse(
  //       'https://10.0.2.2:3001/generateHeatmap?userLocations=14.456,120.9401&userLocations=14.456,120.9401'));

  Future<String> getAllUsers() async {
    var docs = await FirebaseFirestore.instance
        .collection("users")
        .where("location", isNotEqualTo: "0,0")
        .get();

    var returned = "";

    for (var doc in docs.docs) {
      var data = doc.data() as Map;
      returned += "&userLocations=${data['location']}";
    }
    return returned;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AdminTheme,
        child: Scaffold(
          body: SafeArea(
              child: Column(children: [
            AdminUpBar(),
            if (isReady)
              Expanded(
                  child: WebviewScaffold(
                ignoreSSLErrors: true,
                url:
                    'https://api.vtavxsrv.pro/generateHeatmap?userLocations=0,0${users}',
              )),
            AdminBottomBar()
          ])),
        ));
    // return Scaffold(
    //   appBar: AppBar(title: const Text('Flutter Simple Example')),
    //   body: WebViewWidget(controller: controller),
    // );
  }
}
