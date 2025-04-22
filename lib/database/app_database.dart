import 'dart:async';
import 'package:floor/floor.dart';
import 'package:floor_database_flutter/DAO/dao.dart';
import 'package:floor_database_flutter/Entity/student_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';


/*
 cmd: flutter pub run build_runner build

 cmd: generator to create all the necessary implementation
      classes based on our annotations.

 cmd2: flutter pub run build_runner watch

 cmd2: This command watches for changes in your files and automatically
       regenerates the code when needed.

 */
@Database(version: 1, entities: [Student])
abstract class AppDatabase extends FloorDatabase{
  StudentDao get studentDao;

  static Future<AppDatabase> init() async{
    return await $FloorAppDatabase
        .databaseBuilder('app_database.db')
        .build();
  }
}

