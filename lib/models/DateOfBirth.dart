class DateOfBirth {
  String year;
  String month;
  String day;

  DateOfBirth({required this.year, required this.month, required this.day});

  Map serializeIntoMap() {
    return {
      'year': year,
      'month': month,
      'day': day,
    };
  }
}
