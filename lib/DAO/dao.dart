
// When need to access and manipulate data in our database. Then DAO come!

import 'package:floor/floor.dart';
import 'package:floor_database_flutter/Entity/student_entity.dart';

@dao
abstract class StudentDao{
  @Query('SELECT * FROM Student')
  Future<List<Student>> getAllStudents();

  @Query('SELECT * FROM Student')
  Stream<List<Student>> streamAllStudents();    // Real-time updates
  //  Stream version is super powerful because it will continuously emit new values whenever the database changes!

  @Insert(onConflict: OnConflictStrategy.ignore)  // Use OnConflictStrategy.ignore to prevent duplicate entries.
  Future<void> insertStudent(Student student);

  @Query('DELETE FROM Student WHERE id= :id')
  Future<void> deleteStudentById(int id);
}