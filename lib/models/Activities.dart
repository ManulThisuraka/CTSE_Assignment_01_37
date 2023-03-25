import 'dart:ffi';

//Activity 1
class Activity {
  String title;
  String description;
  String type;
  Array items;
  DateTime date;

  Activity({
    required this.title,
    required this.description,
    required this.type,
    required this.items,
    required this.date,
  });
}
