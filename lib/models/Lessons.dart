import 'dart:ffi';

class Lesson {
  String title;
  String description;
  String submission;
  DateTime date;

  Lesson({
    required this.title,
    required this.description,
    required this.submission,
    required this.date,
  });
}
