import 'package:flutter/material.dart';
import 'package:str8tex_frontend/LevelManagement/Types/level_type.dart';
import 'package:str8tex_frontend/LevelManagement/Level_Manager_Helpers/sqflite_worker.dart';
import 'package:str8tex_frontend/LevelManagement/level_manager_provider.dart';
import 'Types/board_state_type.dart';

class BoardStateProvider extends ChangeNotifier {
  BoardState currentBoardState = BoardState();
  bool isFinished = true;

  // Undo Redo Fields
  List<BoardState> history = [];
  int undoCounter = 0;
  BoardState? rememberedState;

  // LevlName, Solution & EmptyBoard
  late String currentLevelName;
  late BoardState emptyBoard;
  late BoardState solutionBoard;

  Future loadBoard(LevelType databaseData) async {
    var newBoardState =
        BoardState.deserializeFromString(databaseData.progressBoardData);

    // Select First standard Cell
    var firstNormalElement = newBoardState.cells
        .firstWhere((element) => element.cellType == CellType.standard);
    firstNormalElement.isSelected = true;

    currentBoardState = newBoardState;
    history.clear();
    undoCounter = 0;
    rememberedState = null;

    currentLevelName = databaseData.levelName;
    emptyBoard = BoardState.createFromJson(
        databaseData.emptyBoardData, databaseData.size);
    solutionBoard = BoardState.createFromJson(
        databaseData.solvedBoardData, databaseData.size);

    isFinished = false;

    notifyListeners();
  }

  void restartLevel() {
    var newBoardState = emptyBoard;

    // Select First standard Cell
    var firstNormalElement = newBoardState.cells
        .firstWhere((element) => element.cellType == CellType.standard);
    firstNormalElement.isSelected = true;

    currentBoardState = newBoardState;
    history.clear();
    undoCounter = 0;
    rememberedState = null;

    notifyListeners();
    SQFLiteWorker.writeNewProgressToDatabase(
        currentLevelName, currentBoardState);
  }

  void selectNewCell(int index) {
    _updateHistory();
    undoCounter = 0;
    currentBoardState.cells
        .firstWhere((element) => element.isSelected)
        .isSelected = false;
    currentBoardState.cells
        .firstWhere((element) => element.index == index)
        .isSelected = true;
    notifyListeners();
  }

  void toggleValue(int pressedValue) {
    _updateHistory();
    var activeCell =
        currentBoardState.cells.firstWhere((element) => element.isSelected);

    if (activeCell.value != pressedValue) {
      activeCell.value = pressedValue;
      activeCell.helperValues = [];
      _checkForGameEnd();
    } else {
      activeCell.value = 0;
    }
    notifyListeners();
    SQFLiteWorker.writeNewProgressToDatabase(
        currentLevelName, currentBoardState);
  }

  _checkForGameEnd() {
    if (currentBoardState.cells.any((element) =>
        element.cellType == CellType.standard && element.value == 0)) return;

    // check if Solution is matched
    var standardCells = currentBoardState.cells
        .where((element) => element.cellType == CellType.standard)
        .toList();
    var solutionValid = true;
    for (var cell in standardCells) {
      var passendeCellInSolution = solutionBoard.cells[cell.index];
      if (passendeCellInSolution.value != cell.value) {
        solutionValid = false;
        break;
      }
    }

    if (solutionValid) isFinished = true;
    SQFLiteWorker.resetLevelInDatabase(currentLevelName, emptyBoard);
    LevelManagerProvider.instance.changeMetaDataToSolved(currentLevelName);
  }

  void toggleHelperValue(int pressedValue) {
    var activeCell =
        currentBoardState.cells.firstWhere((element) => element.isSelected);
    if (activeCell.value > 0) return;

    _updateHistory();
    if (activeCell.helperValues.contains(pressedValue)) {
      activeCell.helperValues.remove(pressedValue);
    } else {
      activeCell.helperValues.add(pressedValue);
    }

    notifyListeners();
    SQFLiteWorker.writeNewProgressToDatabase(
        currentLevelName, currentBoardState);
  }

  void clearActiveCell() {
    _updateHistory();
    var activeCell =
        currentBoardState.cells.firstWhere((element) => element.isSelected);

    activeCell.value = 0;
    activeCell.helperValues.clear();

    notifyListeners();
    SQFLiteWorker.writeNewProgressToDatabase(
        currentLevelName, currentBoardState);
  }

  void undo() {
    if (undoCounter == 0) rememberedState = currentBoardState.makeCopy();
    undoCounter += 1;
    final currentElementHistoryIndex = history.length - undoCounter;
    if (currentElementHistoryIndex < 0) {
      undoCounter -= 1;
      return;
    }
    currentBoardState = history[currentElementHistoryIndex].makeCopy();
    notifyListeners();
    SQFLiteWorker.writeNewProgressToDatabase(
        currentLevelName, currentBoardState);
  }

  void redo() {
    if (undoCounter == 0) return;
    undoCounter -= 1;
    if (undoCounter == 0) {
      currentBoardState = (rememberedState as BoardState).makeCopy();
      rememberedState = null;
      notifyListeners();
      return;
    }
    final currentElementHistoryIndex = history.length - undoCounter;
    currentBoardState = history[currentElementHistoryIndex].makeCopy();
    notifyListeners();
    SQFLiteWorker.writeNewProgressToDatabase(
        currentLevelName, currentBoardState);
  }

  void _updateHistory() {
    if (undoCounter > 0) {
      // Whenever a change is made while history element is active then drop all future elements
      final currentElementHistoryIndex = history.length - undoCounter;
      history = history.sublist(0, currentElementHistoryIndex + 1);
      undoCounter = 0;
    }
    history.add(currentBoardState.makeCopy());
  }
}
