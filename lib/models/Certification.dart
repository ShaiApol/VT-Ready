import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/utils.dart';

import 'Cards.dart';

class Certification {
  final String name;
  final String activity_photo;
  final Map<String, dynamic> date;
  bool? rated;
  DocumentReference ref;
  String? photo;

  Certification({
    required this.name,
    required this.ref,
    required this.date,
    required this.activity_photo,
    required this.rated,
    this.photo,
  });

  Widget renderAsRowExpandedCard(
      {required Function() onPressed, required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFF283F4D)),
              clipBehavior: Clip.hardEdge,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Header3(text: name),
                        SizedBox(height: 8),
                        Text("Certificate received on " +
                            retrieveStringFormattedDate(date)),
                        Row(
                          children: [
                            if (photo != null && photo!.isNotEmpty)
                              GestureDetector(
                                onTap: onPressed,
                                child: Text("See Certificate",
                                    style:
                                        TextStyle(color: Colors.yellow[600])),
                              )
                            else
                              Text("Certificate not available"),
                            SizedBox(
                              width: 8,
                            ),
                            if (rated == false || rated == null)
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Rate(
                                      ref: ref,
                                      name: name,
                                      date: date,
                                      activity_photo: activity_photo,
                                      rated: rated,
                                      photo: photo,
                                    );
                                  }));
                                },
                                child: Text("Rate",
                                    style:
                                        TextStyle(color: Colors.yellow[600])),
                              )
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(child: SizedBox.shrink()),
                  Image.network(
                    activity_photo,
                    height: 96,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}

class Rate extends StatefulWidget {
  final DocumentReference ref;
  final String name;
  final String activity_photo;
  final Map<String, dynamic> date;
  final bool? rated;
  String? photo;

  Rate({
    required this.ref,
    required this.name,
    required this.date,
    required this.activity_photo,
    required this.rated,
    this.photo,
  });

  @override
  _RateState createState() => _RateState();
}

class _RateState extends State<Rate> {
  int rating1 = 0, rating2 = 0, rating3 = 0;
  Future<DocumentSnapshot> fetch() async {
    return await widget.ref.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          UpBar(),
          Expanded(
              child: ListView(
            children: [
              FutureBuilder(
                  future: fetch(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      if ((snapshot.data!.data() as Map)['rated'] != null) {
                        return Container(
                            height: MediaQuery.of(context).size.height * 0.735,
                            child: Center(
                              child: Text(
                                  "You have already rated this actibvity."),
                            ));
                      } else {
                        return Padding(
                            padding: EdgeInsets.all(16),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.735,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rate Training",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        widget.name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ))
                                    ],
                                  ),
                                  SizedBox(height: 32),
                                  Row(children: [
                                    Expanded(
                                        child: Image.network(
                                      widget.activity_photo,
                                      height: 160,
                                      fit: BoxFit.contain,
                                    ))
                                  ]),
                                  SizedBox(height: 16),
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text("Usefulness"),
                                            Expanded(child: SizedBox.shrink()),
                                            RatingBar.builder(
                                              initialRating: 0,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                setState(() {
                                                  rating1 = int.parse(rating
                                                      .toString()
                                                      .split(".")[0]);
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Time Management"),
                                            Expanded(child: SizedBox.shrink()),
                                            RatingBar.builder(
                                              initialRating: 0,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                setState(() {
                                                  rating2 = int.parse(rating
                                                      .toString()
                                                      .split(".")[0]);
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Satifaction"),
                                            Expanded(child: SizedBox.shrink()),
                                            RatingBar.builder(
                                              initialRating: 0,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                setState(() {
                                                  rating3 = int.parse(rating
                                                      .toString()
                                                      .split(".")[0]);
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        Row(children: [Text("Feedback")]),
                                        SizedBox(height: 8),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFF29404E),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            padding: EdgeInsets.all(8),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  border: InputBorder.none),
                                              maxLines: 5,
                                            ))
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                  )),
                                  SizedBox(height: 16),
                                  Align(
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          if (rating1 != 0 &&
                                              rating2 != 0 &&
                                              rating3 != 0) {
                                            await widget.ref
                                                .update({"rated": true});
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text(
                                          "Submit",
                                          style: TextStyle(color: Colors.black),
                                        )),
                                  )
                                ],
                              ),
                            ));
                      }
                    }
                    return SizedBox.shrink();
                  }))
            ],
          )),
          BottomBar()
        ],
      )),
    );
  }
}
