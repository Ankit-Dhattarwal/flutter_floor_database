
import 'package:floor/floor.dart';

@entity
class Student{
  @primaryKey
  final int? id; // Nullable for auto-increment

  @ColumnInfo(name: 'name')
  final String name;

  @ColumnInfo(name: 'age')
  final int age;

  Student({this.id, required this.name, required this.age});
}