import 'dart:convert';

import 'package:str8tex_frontend/Board/Types/board_state_type.dart';

class LevelType {
  late String levelIdentifier;
  late String levelDisplayName;
  late String emptyBoardData;
  late String progressBoardData;
  late BoardState progressBoardDataObject;
  late String solvedBoardData;
  late int size;
  late int time;
  late int clusterId;
  late String clusterName;

  static LevelType fromLevelFile(String rawData, int clusterID) {
    final data = json.decode(rawData);
    final newDataPiece = LevelType()
      ..levelIdentifier = data["levelIdentifier"]
      ..levelDisplayName = data["levelDisplayName"]
      ..emptyBoardData = json.encode(data["EmptyBoard"])
      ..solvedBoardData = json.encode(data["SolutionBoard"])
      ..clusterId = clusterID
      ..time = 0
      ..size = data["size"];

    return newDataPiece;
  }
}
