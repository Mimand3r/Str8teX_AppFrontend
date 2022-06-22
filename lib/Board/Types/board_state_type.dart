import 'dart:convert';

class BoardState {
  int size = 9;
  List<BoardStateCell> cells = [];

  BoardState makeCopy() => BoardState()
    ..size = size
    ..cells = cells.map((e) => e.makeCopy()).toList();

  static BoardState createFromJson(String json, int size) {
    var newBoardState = BoardState()..size = size;
    List<dynamic> cellList = jsonDecode(json);
    var indexCounter = 0;
    for (var cellListElement in cellList) {
      var newCell = BoardStateCell();
      newCell.value = cellListElement["number"];
      if (cellListElement["type"] == "block") {
        newCell.cellType = CellType.block;
      } else {
        newCell.cellType =
            newCell.value == 0 ? CellType.standard : CellType.prefilled;
      }
      newCell.row = (indexCounter / newBoardState.size).floor();
      newCell.col = indexCounter % newBoardState.size;
      newCell.index = indexCounter++;

      newBoardState.cells.add(newCell);
    }

    return newBoardState;
  }

  String serializeToString() {
    var map = <String, dynamic>{};
    map["size"] = size;
    map["cells"] = cells.map((cell) {
      var cellMap = <String, dynamic>{};
      cellMap["cellType"] = cell.cellType == CellType.standard
          ? "standard"
          : cell.cellType == CellType.block
              ? "block"
              : "prefilled";
      cellMap["value"] = cell.value;
      cellMap["index"] = cell.index;
      cellMap["helperValues"] = cell.helperValues;
      cellMap["row"] = cell.row;
      cellMap["col"] = cell.col;
      return cellMap;
    }).toList();

    return json.encode(map);
  }

  static BoardState deserializeFromString(String stringData) {
    var mapData = json.decode(stringData) as Map<String, dynamic>;
    var extractedState = BoardState()
      ..size = mapData["size"]
      ..cells = List<dynamic>.from(mapData["cells"])
          .map((c) => BoardStateCell()
            ..cellType = c["cellType"] == "standard"
                ? CellType.standard
                : c["cellType"] == "block"
                    ? CellType.block
                    : CellType.prefilled
            ..value = c["value"]
            ..index = c["index"]
            ..helperValues = List<int>.from(c["helperValues"])
            ..row = c["row"]
            ..col = c["col"])
          .toList();

    return extractedState;
  }
}

class BoardStateCell {
  CellType cellType = CellType.standard;
  int value = 0;
  int index = 0;
  List<int> helperValues = [];
  bool isSelected = false;
  int row = 0;
  int col = 0;

  BoardStateCell makeCopy() => BoardStateCell()
    ..cellType = cellType
    ..value = value
    ..index = index
    ..helperValues = List<int>.from(helperValues)
    ..isSelected = isSelected
    ..row = row
    ..col = col;
}

enum CellType { standard, block, prefilled }
