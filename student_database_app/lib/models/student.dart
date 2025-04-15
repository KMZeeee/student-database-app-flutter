import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int id;

  @HiveField(2)
  String major;

  Student({required this.name, required this.id, required this.major});
}
