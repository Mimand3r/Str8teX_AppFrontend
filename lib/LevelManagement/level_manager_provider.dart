import 'package:flutter/material.dart';
import 'package:str8tex_frontend/LevelManagement/Types/database_level_type.dart';
import 'package:str8tex_frontend/LevelManagement/Types/level_meta_type.dart';
import 'package:str8tex_frontend/LevelManagement/Level_Manager_Helpers/preinstalled_levels_worker.dart';
import 'package:str8tex_frontend/LevelManagement/Level_Manager_Helpers/sqflite_worker.dart';

class LevelManagerProvider extends ChangeNotifier {
  late List<LevelMetaType> levelMetaData;

  static late LevelManagerProvider instance;

  LevelManagerProvider() {
    instance = this;
  }

  Future initializeLevels() async {
    // Update internal Level Data for preinstalled Levels
    await SQFLiteWorker.openDatabaseForAppSession();
    await SQFLiteWorker.createDatabaseTablesIfNotExistant();
    final clusterIdsAndLevelNames =
        await SQFLiteWorker.getAllStoredClusterIdsAndLevelNames();
    final clusterIds = clusterIdsAndLevelNames[0] as List<int>;
    final levelNames = clusterIdsAndLevelNames[1] as List<String>;
    await PreinstalledLevelWorker
        .storeInitialLevelsAndClustersIntoDatabaseIfNotExistant(
            clusterIds, levelNames);

    // // Update internal Level Data for Firebase Levels
    // var firebaseLevelNames =
    //     await FirebaseStorageWorker.fetchLevelNamesFromFirebase();
    // await FirebaseStorageWorker.downloadAndStoreMissingLevels(
    //     firebaseLevelNames, storedLevels);

    // // Load Metadata for all internal Levels
    // levelMetaData = await SQFLiteWorker.fetchMetaDataForAllStoredLevels();
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
