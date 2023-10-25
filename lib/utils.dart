import 'dart:developer';

String retrieveStringFormattedDate(Map<String, dynamic> date) {
  log(date.toString());
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return "${months[date['month']! - 1]} ${date['day']}, ${date['year']}";
}

bool isDateBeforeToday(Map<String, dynamic> date) {
  DateTime today = DateTime.now();
  DateTime dateToCompare = DateTime(
    int.parse(date['year']),
    int.parse(date['month']),
    int.parse(date['day']),
  );
  return dateToCompare.isBefore(today);
}
