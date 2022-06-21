import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:str8tex_frontend/LevelManagement/Types/db_level_type.dart';

class BoardStateProvider extends ChangeNotifier {
  BoardState boardState = BoardState();
  List<BoardState> history = [];
  int undoCounter = 0;

  Future loadBoard(DatabaseLevelType databaseData) async {
    var newBoardState = BoardState()..size = databaseData.size;
    List<dynamic> cellList = jsonDecode(databaseData.emptyBoardData);
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

    // Select First standard Cell
    var firstNormalElement = newBoardState.cells
        .firstWhere((element) => element.cellType == CellType.standard);
    firstNormalElement.isSelected = true;

    boardState = newBoardState;
    notifyListeners();
  }

  void selectNewCell(int index) {
    _updateHistory();
    undoCounter = 0;
    boardState.cells.firstWhere((element) => element.isSelected).isSelected =
        false;
    boardState.cells
        .firstWhere((element) => element.index == index)
        .isSelected = true;
    notifyListeners();
  }

  void toggleValue(int pressedValue) {
    _updateHistory();
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
    if (activeCell.value > 0) return;

    _updateHistory();
    if (activeCell.helperValues.contains(pressedValue)) {
      activeCell.helperValues.remove(pressedValue);
    } else {
      activeCell.helperValues.add(pressedValue);
    }

    notifyListeners();
  }

  void clearActiveCell() {
    _updateHistory();
    var activeCell =
        boardState.cells.firstWhere((element) => element.isSelected);

    activeCell.value = 0;
    activeCell.helperValues.clear();

    notifyListeners();
  }

  BoardState? rememberedState;

  void undo() {
    if (undoCounter == 0) rememberedState = boardState.makeCopy();
    undoCounter += 1;
    final currentElementHistoryIndex = history.length - undoCounter;
    if (currentElementHistoryIndex < 0) {
      undoCounter -= 1;
      return;
    }
    boardState = history[currentElementHistoryIndex].makeCopy();
    notifyListeners();
  }

  void redo() {
    if (undoCounter == 0) return;
    undoCounter -= 1;
    if (undoCounter == 0) {
      boardState = (rememberedState as BoardState).makeCopy();
      rememberedState = null;
      notifyListeners();
      return;
    }
    final currentElementHistoryIndex = history.length - undoCounter;
    boardState = history[currentElementHistoryIndex].makeCopy();
    notifyListeners();
  }

  void _updateHistory() {
    if (undoCounter > 0) {
      // Whenever a change is made while history element is active then drop all future elements
      final currentElementHistoryIndex = history.length - undoCounter;
      history = history.sublist(0, currentElementHistoryIndex + 1);
      undoCounter = 0;
    }
    history.add(boardState.makeCopy());
  }
}

class BoardState {
  int size = 9;
  List<BoardStateCell> cells = [];

  BoardState makeCopy() => BoardState()
    ..size = size
    ..cells = cells.map((e) => e.makeCopy()).toList();
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
