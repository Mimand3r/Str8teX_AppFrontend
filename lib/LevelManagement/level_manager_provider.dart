import 'package:flutter/material.dart';
import 'package:str8tex_frontend/LevelManagement/Types/level_type.dart';
import 'package:str8tex_frontend/LevelManagement/Types/meta_data_type.dart';
import 'package:str8tex_frontend/LevelManagement/Level_Manager_Helpers/preinstalled_levels_worker.dart';
import 'package:str8tex_frontend/LevelManagement/Level_Manager_Helpers/sqflite_worker.dart';

class LevelManagerProvider extends ChangeNotifier {
  late List<MetaDataType> levelMetaData;

  static late LevelManagerProvider instance;

  LevelManagerProvider() {
    instance = this;
  }

  // Diese Methode muss bei jedem App Start durchlaufen werden.
  //Sie wird vom StartupLoading Module gemanaged
  Future initializeDatabaseOnAppstart() async {
    // Open or Create new DB
    await SQFLiteWorker.openDatabaseForAppSession();
    await SQFLiteWorker.createDatabaseTablesIfNotExistant();
    final clusterIdsAndLevelNames =
        await SQFLiteWorker.getAllStoredDataIDsOrNames();
    final clusterIds = clusterIdsAndLevelNames[0] as List<int>;
    final levelNames = clusterIdsAndLevelNames[1] as List<String>;
    await PreinstalledLevelWorker
        .storeInitialLevelsAndClustersIntoDatabaseIfNotExistant(
            clusterIds, levelNames);

    // Load Metadata for all internal Levels
    levelMetaData = await SQFLiteWorker.fetchMetaDataForAllStoredLevels();
  }

  Future<LevelType> loadSpecificLevelData(String levelName) async {
    var data =
        await SQFLiteWorker.fetchFullStoredLevelDataForSpecificLevel(levelName);
    return data;
  }

  void changeMetaDataToSolved(String levelName) {
    debugPrint("got executed");
    levelMetaData
        .firstWhere((element) => element.levelIdentifier == levelName)
        .isSolved = true;
    notifyListeners();
  }
}
