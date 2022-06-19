import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:str8tex_frontend/LevelManagement/Types/level_meta_type.dart';

import '../Types/db_level_type.dart';

class SQFLiteWorker {
  static const String databaseName = "strate_x_main.db";
  static const String tableLevels = "levels";

  static late Database openedDatabase;

  static Future openDatabaseForSession() async {
    // Opens Database and Creates Tables
    var databaseRootPath = await getDatabasesPath();
    var dbPath = join(databaseRootPath, tableLevels);
    openedDatabase = await openDatabase(dbPath, version: 1);
  }

  static Future createTablesIfNotExistant() async {
    // await openedDatabase.execute("DROP TABLE IF EXISTS $tableLevels");
    // Table 1: Levels
    await openedDatabase.execute("CREATE TABLE IF NOT EXISTS $tableLevels ("
        "id INTEGER PRIMARY KEY,"
        "level_name TEXT,"
        "empty_board TEXT,"
        "progress_board TEXT,"
        "solution_board TEXT,"
        "size INTEGER,"
        "curr_time INTEGER,"
        "rekord_time INTEGER"
        ")");

    // await openedDatabase.transaction((txn) async {
    //   int id1 = await txn.rawInsert(
    //       'INSERT INTO $tableLevels(level_name, size) VALUES("level_001", 9)');
    //   debugPrint('inserted1: $id1');
    //   int id2 = await txn.rawInsert(
    //       'INSERT INTO $tableLevels(level_name, size) VALUES("level_002", 9)');
    //   debugPrint('inserted2: $id2');
    // });
  }

  static Future<List<String>> getAllStoredLevelNames() async {
    var queryResult =
        await openedDatabase.rawQuery('SELECT level_name FROM $tableLevels');

    var nameList = queryResult.map((x) => x["level_name"] as String).toList();

    return nameList;
  }

  static Future storeLevelsInDatabase(
      List<DatabaseLevelType> unstoredLevels) async {
    await openedDatabase.transaction((txn) async {
      for (var unstoredLevel in unstoredLevels) {
        var id = await txn.rawInsert(
            "INSERT INTO $tableLevels(level_name, empty_board, progress_board, solution_board, size, curr_time, rekord_time)"
            "VALUES('${unstoredLevel.levelName}','${unstoredLevel.emptyBoardData}',"
            "'${unstoredLevel.emptyBoardData}', '${unstoredLevel.solvedBoardData}', ${unstoredLevel.size},"
            "0, 0)");
        debugPrint("New Element with ID $id inserted");
      }
    });
  }

  static Future<List<LevelMetaType>> fetchMetaDataForAllLevels() async {
    var query = await openedDatabase.rawQuery(
        'SELECT level_name, size, curr_time, rekord_time FROM $tableLevels');

    List<LevelMetaType> metaListe = [];

    for (var el in query) {
      var newElement = LevelMetaType(
        levelName: el["level_name"] as String,
        currentTime: el["curr_time"] as int,
        rekordTime: el["rekord_time"] as int,
        size: el["size"] as int,
      );
      metaListe.add(newElement);
    }

    return metaListe;
  }

  static Future<DatabaseLevelType> fetchFullLevelData(String levelName) async {
    var query = await openedDatabase
        .rawQuery("SELECT * FROM $tableLevels WHERE level_name = '$levelName'");
    return DatabaseLevelType()
      ..levelName = query.first["level_name"] as String
      ..emptyBoardData = query.first["empty_board"] as String
      ..solvedBoardData = query.first["solution_board"] as String
      ..size = query.first["size"] as int;
  }
}
