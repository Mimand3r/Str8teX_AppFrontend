import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:str8tex_frontend/Board/Types/board_state_type.dart';
import 'package:str8tex_frontend/LevelManagement/Types/level_meta_type.dart';
import '../Types/database_cluster_type.dart';
import '../Types/database_level_type.dart';

class SQFLiteWorker {
  static late Database openedDatabase;

  static Future openDatabaseForAppSession() async {
    // Opens Database and Creates Tables
    var databaseRootPath = await getDatabasesPath();
    var dbPath = join(databaseRootPath, "strate_x_main.db");

    Future _onConfigure(Database db) async =>
        await db.execute('PRAGMA foreign_keys = ON');

    openedDatabase =
        await openDatabase(dbPath, version: 1, onConfigure: _onConfigure);

    // // To get DB Size in Byte:
    // final file = File(dbPath);
    // final size = await file.length();
    // debugPrint(size.toString());
  }

  static Future createDatabaseTablesIfNotExistant() async {
    // await openedDatabase.execute("DROP TABLE IF EXISTS levels");
    // Table 1: Clusters
    await openedDatabase.execute("CREATE TABLE IF NOT EXISTS clusters ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT"
        ")");
    // Table 2: Levels
    await openedDatabase.execute("CREATE TABLE IF NOT EXISTS levels ("
        "id INTEGER PRIMARY KEY,"
        "level_name TEXT,"
        "empty_board TEXT,"
        "progress_board TEXT,"
        "solution_board TEXT,"
        "size INTEGER,"
        "is_solved BOOLEAN," // 0 oder 1
        "cluster_id INTEGER,"
        "FOREIGN KEY (cluster_id) REFERENCES clusters (id) ON DELETE NO ACTION ON UPDATE NO ACTION"
        ")");
  }

  static Future<List> getAllStoredClusterIdsAndLevelNames() async {
    var queryResultClusters =
        await openedDatabase.rawQuery('SELECT id FROM clusters');
    var clusterList = queryResultClusters.map((x) => x["id"] as int).toList();
    var queryResultLevels =
        await openedDatabase.rawQuery('SELECT level_name FROM levels');
    var levelList =
        queryResultLevels.map((x) => x["level_name"] as String).toList();

    return [clusterList, levelList];
  }

  static Future writeClustersToDb(
      List<DatabaseClusterType> unstoredClusters) async {
    await openedDatabase.transaction((txn) async {
      for (var unstoredCluster in unstoredClusters) {
        var emptyProgressBoard = BoardState.createFromJson(
                unstoredLevel.emptyBoardData, unstoredLevel.size)
            .serializeToString();

        var id = await txn.rawInsert(
            "INSERT INTO levels(level_name, empty_board, progress_board, solution_board, size, is_solved)"
            "VALUES('${unstoredLevel.levelName}','${unstoredLevel.emptyBoardData}',"
            "'$emptyProgressBoard', '${unstoredLevel.solvedBoardData}', ${unstoredLevel.size},"
            "0)");
        debugPrint("New Element with ID $id inserted");
      }
    });
  }

  static Future storeLevelsInDatabase(
      List<DatabaseLevelType> unstoredLevels) async {
    await openedDatabase.transaction((txn) async {
      for (var unstoredLevel in unstoredLevels) {
        var emptyProgressBoard = BoardState.createFromJson(
                unstoredLevel.emptyBoardData, unstoredLevel.size)
            .serializeToString();

        var id = await txn.rawInsert(
            "INSERT INTO levels(level_name, empty_board, progress_board, solution_board, size, is_solved)"
            "VALUES('${unstoredLevel.levelName}','${unstoredLevel.emptyBoardData}',"
            "'$emptyProgressBoard', '${unstoredLevel.solvedBoardData}', ${unstoredLevel.size},"
            "0)");
        debugPrint("New Element with ID $id inserted");
      }
    });
  }

  static Future<List<LevelMetaType>> fetchMetaDataForAllStoredLevels() async {
    var query = await openedDatabase
        .rawQuery('SELECT level_name, size, is_solved FROM levels');

    List<LevelMetaType> metaListe = [];

    for (var el in query) {
      var newElement = LevelMetaType(
        levelName: el["level_name"] as String,
        isSolved: el["is_solved"] != 0,
        size: el["size"] as int,
      );
      metaListe.add(newElement);
    }

    return metaListe;
  }

  static Future<DatabaseLevelType> fetchFullStoredLevelDataForSpecificLevel(
      String levelName) async {
    var query = await openedDatabase
        .rawQuery("SELECT * FROM levels WHERE level_name = '$levelName'");
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
        "UPDATE levels SET progress_board = ? WHERE level_name = '$levelName'",
        [boardState.serializeToString()]);
  }

  static Future writeIsSolvedToDatabaseAndResetProgress(
      String levelName, BoardState emptyBoard) async {
    await openedDatabase.rawUpdate(
        "UPDATE levels SET is_solved = 1 WHERE level_name = '$levelName'");
    await openedDatabase.rawUpdate(
        "UPDATE levels SET progress_board = ? WHERE level_name = '$levelName'",
        [emptyBoard.serializeToString()]);
  }
}
