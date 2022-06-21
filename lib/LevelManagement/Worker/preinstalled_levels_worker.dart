import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:str8tex_frontend/LevelManagement/Types/db_level_type.dart';
import 'package:str8tex_frontend/LevelManagement/Worker/sqflite_worker.dart';

class PreinstalledLevelWorker {
  static const List<String> initialLevels = [
    "initial_level_001.json",
    "initial_level_002.json",
    "initial_level_003.json",
    "initial_level_004.json",
    "initial_level_005.json",
    "initial_level_006.json",
    "initial_level_007.json",
  ];

  static Future storeInitialLevelsIntoDatabaseIfNotExistant(
      List<String> databaseLevels) async {
    // Finde raus welche Daten in DB fehlen
    var namesInitialLevelsNotInDatabase = initialLevels
        .where((element) => !databaseLevels.contains(element))
        .toList();

    // Fetch Daten from files und package for DB
    List<DatabaseLevelType> unstoredLevels = [];

    for (var levelName in namesInitialLevelsNotInDatabase) {
      final jsonText =
          await rootBundle.loadString('assets/$levelName', cache: false);
      final data = json.decode(jsonText);
      final newData = DatabaseLevelType()
        ..levelName = levelName
        ..emptyBoardData = json.encode(data["EmptyBoard"]["cells"])
        ..solvedBoardData = json.encode(data["Solution"]["cells"])
        ..size = data["Solution"]["size"];

      unstoredLevels.add(newData);
    }

    // Pass Data to SQFlite Worker so that new Entrys can be added
    await SQFLiteWorker.storeLevelsInDatabase(unstoredLevels);
  }
}
