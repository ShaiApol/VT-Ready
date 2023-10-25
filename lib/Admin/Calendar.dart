import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'Event.dart';
import 'Training.dart';

class Calendar extends StatefulWidget {
  List<Event> events;
  List<Training> trainings;
  Calendar({Key? key, required this.events, required this.trainings})
      : super(key: key);
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    widget.events.forEach((element) {
      meetings.add(Meeting(
          element.name,
          DateTime.parse(
              '${element.date['year']}-${element.date['month'] < 10 ? "0${element.date['month']}" : "${element.date['month']}"}-${element.date['day'] < 10 ? "0${element.date['day']}" : "${element.date['day']}"} 09:00:00'),
          Colors.blue,
          true));
    });
    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(8),
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: MeetingDataSource(_getDataSource()),
          monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
              showAgenda: true),
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].time;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].time;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.time, this.background, this.isAllDay);

  String eventName;
  DateTime time;
  Color background;
  bool isAllDay;
}
