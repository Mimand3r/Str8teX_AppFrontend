import 'dart:convert';

class BoardState {
  int size = 9;
  List<BoardStateCell> cells = [];

  BoardState makeCopy() => BoardState()
    ..size = size
    ..cells = cells.map((e) => e.makeCopy()).toList()
    .._calcStr8tes();

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

    newBoardState._calcStr8tes();

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

    extractedState._calcStr8tes();

    return extractedState;
  }

  _calcStr8tes() {
    for (var cell in cells) {
      if (cell.cellType == CellType.block) continue;
      // find hor str8te partners
      var allRowPartners =
          cells.where((element) => element.row == cell.row).toList();
      var cellRowIndex = allRowPartners.indexOf(cell);
      var horStrateStart = 0;
      for (var i = cellRowIndex; i > -1; i--) {
        if (allRowPartners[i].cellType == CellType.block) {
          horStrateStart = i + 1;
          break;
        }
      }
      var horStrateEnd = allRowPartners.length - 1;
      for (var i = cellRowIndex; i < allRowPartners.length; i++) {
        if (allRowPartners[i].cellType == CellType.block) {
          horStrateEnd = i - 1;
          break;
        }
      }
      cell.horizontalStr8te =
          allRowPartners.sublist(horStrateStart, horStrateEnd + 1);

      // find vert str8te partners

      var allColPartners =
          cells.where((element) => element.col == cell.col).toList();
      var cellColIndex = allColPartners.indexOf(cell);
      var vertStrateStart = 0;
      for (var i = cellColIndex; i > -1; i--) {
        if (allColPartners[i].cellType == CellType.block) {
          vertStrateStart = i + 1;
          break;
        }
      }
      var vertStrateEnd = allColPartners.length - 1;
      for (var i = cellColIndex; i < allColPartners.length; i++) {
        if (allColPartners[i].cellType == CellType.block) {
          vertStrateEnd = i - 1;
          break;
        }
      }

      cell.verticalStr8te =
          allColPartners.sublist(vertStrateStart, vertStrateEnd + 1);
    }
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
  List<BoardStateCell> horizontalStr8te = [];
  List<BoardStateCell> verticalStr8te = [];

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
