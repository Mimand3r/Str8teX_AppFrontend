import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoardStateProvider extends ChangeNotifier {
  BoardState boardState = BoardState();

  Future loadJSONBoard() async {
    var text = await rootBundle.loadString('assets/example_board.json');
    Map<String, dynamic> jsonData = jsonDecode(text);

    var newBoardState = BoardState();
    newBoardState.size = jsonData["size"];
    var cellList = List.from(jsonData["cells"]);
    var indexCounter = 0;
    for (var cellListElement in cellList) {
      var newCell = BoardStateCell();
      newBoardState.cells.add(newCell);

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
    }

    // Select First standard Cell
    var firstNormalElement = newBoardState.cells
        .firstWhere((element) => element.cellType == CellType.standard);
    firstNormalElement.isSelected = true;

    boardState = newBoardState;
    notifyListeners();
  }

  void selectNewCell(int index) {
    boardState.cells.firstWhere((element) => element.isSelected).isSelected =
        false;
    boardState.cells
        .firstWhere((element) => element.index == index)
        .isSelected = true;
    notifyListeners();
  }

  void toggleValue(int pressedValue) {
    var activeCell =
        boardState.cells.firstWhere((element) => element.isSelected);

    if (activeCell.value != pressedValue) {
      activeCell.value = pressedValue;
      activeCell.helperValues = [];
    } else {
      activeCell.value = 0;
    }
    notifyListeners();
  }

  void toggleHelperValue(int pressedValue) {
    var activeCell =
        boardState.cells.firstWhere((element) => element.isSelected);

    if (activeCell.helperValues.contains(pressedValue)) {
      activeCell.helperValues.remove(pressedValue);
    } else {
      activeCell.helperValues.add(pressedValue);
    }

    notifyListeners();
  }

  void clearActiveCell() {
    var activeCell =
        boardState.cells.firstWhere((element) => element.isSelected);

    activeCell.value = 0;
    activeCell.helperValues.clear();

    notifyListeners();
  }
}

class BoardState {
  int size = 9;
  List<BoardStateCell> cells = [];
}

class BoardStateCell {
  CellType cellType = CellType.standard;
  int value = 0;
  int index = 0;
  List<int> helperValues = [];
  bool isSelected = false;
  int row = 0;
  int col = 0;
}

enum CellType { standard, block, prefilled }
