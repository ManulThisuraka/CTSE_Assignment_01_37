import 'dart:ffi';

class Food {
  String title;
  String description;
  String allocatedDay;
  DateTime date;

  Food({
    required this.title,
    required this.description,
    required this.allocatedDay,
    required this.date,
  });
}
