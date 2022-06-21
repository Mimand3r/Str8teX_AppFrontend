import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:str8tex_frontend/LevelManagement/Types/db_level_type.dart';
import 'package:str8tex_frontend/LevelManagement/Types/level_meta_type.dart';
import 'package:str8tex_frontend/LevelManagement/Worker/preinstalled_levels_worker.dart';
import 'package:str8tex_frontend/LevelManagement/Worker/sqflite_worker.dart';

import 'Worker/firebase_storage_worker.dart';

class LevelManager extends ChangeNotifier {
  late List<LevelMetaType> levelMetaData;

  Future initializeLevels() async {
    debugPrint("Hallo Level Manager");

    // Update internal Level Data for preinstalled Levels
    await SQFLiteWorker.openDatabaseForSession();
    await SQFLiteWorker.createTablesIfNotExistant();
    var storedLevels = await SQFLiteWorker.getAllStoredLevelNames();
    await PreinstalledLevelWorker.storeInitialLevelsIntoDatabaseIfNotExistant(
        storedLevels);

    // Update internal Level Data for Firebase Levels
    var firebaseLevelNames =
        await FirebaseStorageWorker.fetchLevelNamesFromFirebase();

    // Load Metadata for all internal Levels
    levelMetaData = await SQFLiteWorker.fetchMetaDataForAllLevels();
    debugPrint("Finished");
  }

  Future<DatabaseLevelType> loadLevelData(String levelName) async {
    var data = await SQFLiteWorker.fetchFullLevelData(levelName);
    return data;
  }
}
