import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:str8tex_frontend/Board/Types/board_state_type.dart';
import 'package:str8tex_frontend/LevelManagement/Types/level_meta_type.dart';
import '../Types/database_level_type.dart';

class SQFLiteWorker {
  static const String databaseName = "strate_x_main.db";
  static const String tableLevels = "levels";

  static late Database openedDatabase;

  static Future openDatabaseForAppSession() async {
    // Opens Database and Creates Tables
    var databaseRootPath = await getDatabasesPath();
    var dbPath = join(databaseRootPath, tableLevels);
    openedDatabase = await openDatabase(dbPath, version: 1);

    // // To get DB Size in Byte:
    // final file = File(dbPath);
    // final size = await file.length();
    // debugPrint(size.toString());
  }

  static Future createDatabaseTablesIfNotExistant() async {
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
        var emptyProgressBoard = BoardState.createFromJson(
                unstoredLevel.emptyBoardData, unstoredLevel.size)
            .serializeToString();

        var id = await txn.rawInsert(
            "INSERT INTO $tableLevels(level_name, empty_board, progress_board, solution_board, size, curr_time, rekord_time)"
            "VALUES('${unstoredLevel.levelName}','${unstoredLevel.emptyBoardData}',"
            "'$emptyProgressBoard', '${unstoredLevel.solvedBoardData}', ${unstoredLevel.size},"
            "0, 0)");
        debugPrint("New Element with ID $id inserted");
      }
    });
  }

  static Future<List<LevelMetaType>> fetchMetaDataForAllStoredLevels() async {
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

  static Future<DatabaseLevelType> fetchFullStoredLevelDataForSpecificLevel(
      String levelName) async {
    var query = await openedDatabase
        .rawQuery("SELECT * FROM $tableLevels WHERE level_name = '$levelName'");
    return DatabaseLevelType()
      ..levelName = query.first["level_name"] as String
      ..emptyBoardData = query.first["empty_board"] as String
      ..progressBoardData = query.first["progress_board"] as String
      ..solvedBoardData = query.first["solution_board"] as String
      ..size = query.first["size"] as int;
  }

  static Future writeProgressToDatabase(
      String levelName, BoardState boardState) async {
    await openedDatabase.rawUpdate(
        "UPDATE $tableLevels SET progress_board = ? WHERE level_name = '$levelName'",
        [boardState.serializeToString()]);
  }
}
