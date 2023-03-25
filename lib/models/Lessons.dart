import 'dart:ffi';

class Lesson {
  String title;
  String description;
  String submission;
  Array items;
  DateTime date;

  Lesson({
    required this.title,
    required this.description,
    required this.submission,
    required this.items,
    required this.date,
  });
}
