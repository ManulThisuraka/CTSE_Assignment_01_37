import 'dart:ffi';

class Food {
  String title;
  String description;
  String allocatedDay;
  Array items;
  DateTime date;

  Food({
    required this.title,
    required this.description,
    required this.allocatedDay,
    required this.items,
    required this.date,
  });
}
