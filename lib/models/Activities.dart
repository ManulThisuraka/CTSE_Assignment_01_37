import 'dart:ffi';

class Activity {
  String title;
  String description;
  String type;
  DateTime date;

  Activity({
    required this.title,
    required this.description,
    required this.type,
    required this.date,
  });
}
