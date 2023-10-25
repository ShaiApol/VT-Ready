import 'package:flutter/material.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/utils.dart';

import 'Cards.dart';

class Event extends Cards {
  final String id;
  final String name;
  final String description;
  final Map<String, dynamic> date;
  final String location;
  final String photo;
  final List<dynamic>? attendees;
  final List<dynamic>? present;
  final List<dynamic>? certificates;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.location,
    required this.photo,
    this.attendees,
    this.present,
    this.certificates,
  });

  Widget renderAsRowExpandedCard({required Function() onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: InkWell(
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFF283F4D)),
              clipBehavior: Clip.hardEdge,
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(retrieveStringFormattedDate(date),
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                        Row(children: [
                          Icon(
                            Icons.location_pin,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(location, style: TextStyle(color: Colors.white))
                        ]),
                      ],
                    ),
                  )),
                  Image.network(
                    photo,
                    height: 96,
                    width: 96,
                    fit: BoxFit.cover,
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
