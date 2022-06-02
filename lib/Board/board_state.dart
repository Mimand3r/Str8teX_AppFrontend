// ignore_for_file: public_member_api_docs, sort_constructors_first
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
        newCell.cellType == CellType.block;
      } else {
        newCell.cellType =
            newCell.value == 0 ? CellType.standard : CellType.prefilled;
      }

      newCell.index = indexCounter++;
    }

    boardState = newBoardState;
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
}

enum CellType { standard, block, prefilled }
