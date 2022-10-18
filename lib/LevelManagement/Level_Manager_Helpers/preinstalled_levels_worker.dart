import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:str8tex_frontend/LevelManagement/Level_Manager_Helpers/sqflite_worker.dart';
import 'package:str8tex_frontend/LevelManagement/Types/cluster_type.dart';
import 'package:str8tex_frontend/LevelManagement/Types/level_type.dart';

class PreinstalledLevelWorker {
  static const String clusterFile = "level_cluster.json";

  static Future storeInitialLevelsAndClustersIntoDatabaseIfNotExistant(
      List<int> currentClusterIds, List<String> currentDatabaseLevels) async {
    // Finde raus welche Clusters und Levels laut ClusterFile existieren müssten
    final clusterText =
        await rootBundle.loadString('assets/$clusterFile', cache: false);
    final clusterData = ClusterType.fromClusterFile(clusterText);

    var definedIDs = clusterData.map((e) => e.index).toList();
    var definedLevels =
        clusterData.fold<List<String>>([], (previousValue, element) {
      previousValue.addAll(element.level);
      return previousValue;
    });

    // Finde raus welche Daten in DB fehlen
    var missingLevelNames = definedLevels
        .where((element) => !currentDatabaseLevels.contains(element))
        .toList();

    var missingClusterIDs = definedIDs
        .where((element) => !currentClusterIds.contains(element))
        .toList();

    // Erzeuge zuerst missing Clusters
    List<ClusterType> missingClustersData = [];
    for (var missingClusterID in missingClusterIDs) {
      missingClustersData.add(clusterData
          .firstWhere((element) => element.index == missingClusterID));
    }

    var update1 = SQFLiteWorker.storeClustersInDatabase(
        missingClustersData); // Pass Data to SQFlite Worker so that new Entrys can be added

    // Erzeuge Nun Missing Levels
    List<LevelType> missingLevelsData = [];

    for (var i = 0; i < missingLevelNames.length; i++) {
      // Für jedes Level parse das korrekte Dokument und lese daten aus
      final jsonText = await rootBundle
          .loadString('assets/${missingLevelNames[i]}', cache: false);
      final data = json.decode(jsonText);

      // Ein Level-JSON Dokument hat folgende struktur:
      // {
      //    size: 9,
      //    levelIdentifier: "Level_01",
      //    levelDisplayName: "Level 1",
      //    EmptyBoard: [List of cells with type & value],
      //    SolutionBoard: [List of cells with type & value]
      // }

      final newDataPiece = LevelType()
        ..levelIdentifier = data["levelIdentifier"]
        ..levelDisplayName = data["levelDisplayName"]
        ..emptyBoardData = json.encode(data["EmptyBoard"])
        ..solvedBoardData = json.encode(data["SolutionBoard"])
        ..clusterId = missingClusterIDs[i]
        ..time = 0
        ..size = data["size"];

      missingLevelsData.add(newDataPiece);
    }

    var update2 = SQFLiteWorker.storeLevelsInDatabase(
        missingLevelsData); // Pass Data to SQFlite Worker so that new Entrys can be added

    await update1;
    await update2;
  }
}
