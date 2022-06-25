import 'package:flutter/material.dart';
import 'package:str8tex_frontend/LevelManagement/Types/database_level_type.dart';
import 'package:str8tex_frontend/LevelManagement/Types/level_meta_type.dart';
import 'package:str8tex_frontend/LevelManagement/Worker/preinstalled_levels_worker.dart';
import 'package:str8tex_frontend/LevelManagement/Worker/sqflite_worker.dart';

import 'Worker/firebase_storage_worker.dart';

class LevelManager extends ChangeNotifier {
  late List<LevelMetaType> levelMetaData;

  static late LevelManager instance;

  LevelManager() {
    instance = this;
  }

  Future initializeLevels() async {
    // Update internal Level Data for preinstalled Levels
    await SQFLiteWorker.openDatabaseForAppSession();
    await SQFLiteWorker.createDatabaseTablesIfNotExistant();
    var storedLevels = await SQFLiteWorker.getAllStoredLevelNames();
    await PreinstalledLevelWorker.storeInitialLevelsIntoDatabaseIfNotExistant(
        storedLevels);

    // Update internal Level Data for Firebase Levels
    var firebaseLevelNames =
        await FirebaseStorageWorker.fetchLevelNamesFromFirebase();
    await FirebaseStorageWorker.downloadAndStoreMissingLevels(
        firebaseLevelNames, storedLevels);

    // Load Metadata for all internal Levels
    levelMetaData = await SQFLiteWorker.fetchMetaDataForAllStoredLevels();
  }

  Future<DatabaseLevelType> loadLevelData(String levelName) async {
    var data =
        await SQFLiteWorker.fetchFullStoredLevelDataForSpecificLevel(levelName);
    return data;
  }

  void changeMetaDataToSolved(String levelName) {
    debugPrint("got executed");
    levelMetaData
        .firstWhere((element) => element.levelName == levelName)
        .isSolved = true;
    notifyListeners();
  }
}
