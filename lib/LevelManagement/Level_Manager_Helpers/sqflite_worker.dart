import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:str8tex_frontend/Board/Types/board_state_type.dart';
import 'package:str8tex_frontend/LevelManagement/Types/cluster_type.dart';
import 'package:str8tex_frontend/LevelManagement/Types/meta_data_type.dart';
import '../Types/level_type.dart';

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
    await openedDatabase.execute("DROP TABLE IF EXISTS levels"); // Dev only
    await openedDatabase.execute("DROP TABLE IF EXISTS clusters"); // Dev only
    // Table 1: Clusters
    await openedDatabase.execute("CREATE TABLE IF NOT EXISTS clusters ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT"
        ")");
    // Table 2: Levels
    await openedDatabase.execute("CREATE TABLE IF NOT EXISTS levels ("
        "id INTEGER PRIMARY KEY,"
        "level_identifier TEXT,"
        "level_display_name TEXT,"
        "empty_board TEXT,"
        "progress_board TEXT,"
        "solution_board TEXT,"
        // Empty Board and SolutionBoard are type JSON
        // They have the following structure:
        // {
        //    "size":9,
        //    "cells":[
        //      {"type":"standard","number":0}...
        //    ]
        //
        // }
        // Progress Board is serialized BoardState class

        "size INTEGER,"
        "status INTEGER," // 0 = unstarted, 1 = inProgress, 2 = finished
        "time INTEGER," // only relevant for finished and inProgress, Einheit: seconds
        "cluster_id INTEGER,"
        "FOREIGN KEY (cluster_id) REFERENCES clusters (id) ON DELETE NO ACTION ON UPDATE NO ACTION"
        ")");
  }

  static Future<List> getAllStoredDataIDsOrNames() async {
    var queryResultClusters =
        await openedDatabase.rawQuery('SELECT id FROM clusters');
    var clusterList = queryResultClusters.map((x) => x["id"] as int).toList();
    var queryResultLevels =
        await openedDatabase.rawQuery('SELECT level_identifier FROM levels');
    var levelList =
        queryResultLevels.map((x) => x["level_identifier"] as String).toList();

    return [clusterList, levelList];
  }

  static Future storeClustersInDatabase(
      List<ClusterType> unstoredClusters) async {
    if (unstoredClusters.isEmpty) return;
    await openedDatabase.transaction((txn) async {
      for (var unstoredCluster in unstoredClusters) {
        var id = await txn.rawInsert("INSERT INTO clusters(id, name)"
            "VALUES('${unstoredCluster.index}', '${unstoredCluster.name}')");
        debugPrint("New Cluster Element with ID $id inserted");
      }
    });
  }

  static Future storeLevelsInDatabase(List<LevelType> unstoredLevels) async {
    await openedDatabase.transaction((txn) async {
      for (var unstoredLevel in unstoredLevels) {
        // create and serialize emptyBoardState-object. This is stored in ProgressData
        var serializedProgressBoard = BoardState.createFromJson(
                unstoredLevel.emptyBoardData, unstoredLevel.size)
            .serializeToString();
        var id = await txn.rawInsert(
            "INSERT INTO levels(level_identifier, level_display_name, empty_board, progress_board, solution_board, size, status, time, cluster_id)"
            "VALUES('${unstoredLevel.levelIdentifier}', '${unstoredLevel.levelDisplayName}','${unstoredLevel.emptyBoardData}',"
            "'$serializedProgressBoard', '${unstoredLevel.solvedBoardData}', '${unstoredLevel.size}', '0', '0',"
            "${unstoredLevel.clusterId})");
        debugPrint("New Level-Element with ID $id inserted");
      }
    });
  }

  static Future<List<MetaDataType>> fetchMetaDataForAllStoredLevels() async {
    var query = await openedDatabase.rawQuery(
        'SELECT level_identifier, level_display_name, size, status, time FROM levels');
    debugPrint("Fetched All Meta Data from db. ${query.length} Elements");
    List<MetaDataType> metaListe = [];

    for (var el in query) {
      var newElement = MetaDataType(
          levelIdentifier: el["level_identifier"] as String,
          levelDisplayName: el["level_display_name"] as String,
          size: el["size"] as int,
          status: (el["status"] as int) == 0
              ? Status.unstarted
              : (el["status"] as int) == 1
                  ? Status.inProgress
                  : Status.finished,
          time: el["time"] as int);
      metaListe.add(newElement);
    }

    return metaListe;
  }

  static Future<LevelType> fetchFullStoredLevelDataForSpecificLevel(
      String levelIdentifier) async {
    var query = await openedDatabase.rawQuery(
        "SELECT * FROM levels WHERE level_identifier = '$levelIdentifier'");
    debugPrint("Fetched Detail Data for Lvl $levelIdentifier");
    return LevelType()
      ..levelIdentifier = query.first["level_identifier"] as String
      ..levelDisplayName = query.first["level_display_name"] as String
      ..emptyBoardData = query.first["empty_board"] as String
      ..progressBoardData = query.first["progress_board"] as String
      ..solvedBoardData = query.first["solution_board"] as String
      ..size = query.first["size"] as int
      ..time = query.first["time"] as int
      ..clusterId = query.first["cluster_id"] as int;
    // TODO how to get foreign key name = clusterName
  }

  static Future writeNewTimeProgressToDatabase(
      String levelName, int newTime) async {
    await openedDatabase.rawUpdate(
        "UPDATE levels SET time = ?, status = 1 WHERE level_identifier = '$levelName'",
        [newTime]);
    debugPrint("Made Progress Write to DB - Reason: Time - $newTime seconds");
  }

  static Future writeNewBoardProgressToDatabase(
      String levelName, BoardState newBoardState, int newTime) async {
    await openedDatabase.rawUpdate(
        "UPDATE levels SET progress_board = ?, time = ?, status = 1 WHERE level_identifier = '$levelName'",
        [newBoardState.serializeToString(), newTime]);
    debugPrint("Made Progress Write to DB - Reason: StateChange");
  }

  static Future writeLevelFinishedToDatabase(
      String levelName, int newTime) async {
    await openedDatabase.rawUpdate(
        "UPDATE levels SET time = ?, status = 2 WHERE level_identifier = '$levelName'",
        [newTime]);
    debugPrint("Level $levelName changed to Finished in DB");
  }

  static Future resetLevelInDatabase(
      String levelName, BoardState emptyBoard) async {
    await openedDatabase.rawUpdate(
        "UPDATE levels SET status = 0, time = 0, progress_board = ? WHERE level_identifier = '$levelName'",
        [emptyBoard.serializeToString()]);
    debugPrint("Level $levelName got reset");
  }
}
