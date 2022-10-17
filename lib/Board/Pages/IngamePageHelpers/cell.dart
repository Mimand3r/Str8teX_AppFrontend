// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:str8tex_frontend/Board/board_state_provider.dart';
import '../../Types/board_state_type.dart';

class Cell extends StatefulWidget {
  final double cellSize;
  final int index;

  const Cell({Key? key, required this.cellSize, required this.index})
      : super(key: key);

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BoardStateProvider>();
    final cellData = provider.currentBoardState.cells
        .firstWhere((element) => element.index == widget.index);

    return GestureDetector(
      onTapDown: (d) {
        if (cellData.cellType != CellType.standard) return;
        if (cellData.isSelected) return;
        context.read<BoardStateProvider>().selectNewCell(cellData.index);
      },
      child: Container(
        width: widget.cellSize,
        height: widget.cellSize,
        decoration: BoxDecoration(
            color: cellData.isSelected
                ? const Color(0xFFFF0000)
                : const Color(0xFF1b2136),
            borderRadius: BorderRadius.circular(10 * widget.cellSize / 100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 2 * widget.cellSize / 100,
                offset: Offset(
                    2 * widget.cellSize / 100, 3 * widget.cellSize / 100),
              )
            ]),
        child: Center(
          child: Container(
            width: 80 * widget.cellSize / 100,
            height: 80 * widget.cellSize / 100,
            decoration: BoxDecoration(
              color: cellData.cellType == CellType.block
                  ? const Color.fromARGB(255, 28, 36, 61)
                  : const Color(0xFF35426b),
              borderRadius: BorderRadius.circular(2 * widget.cellSize / 100),
            ),
            child: Builder(builder: (context) {
              if (cellData.value > 0) {
                return Center(
                    child: Text(
                  cellData.value.toString(),
                  style: TextStyle(
                    color: cellData.cellType == CellType.standard
                        ? colorValues(cellData.value, cellData, provider)
                        : const Color(0xFF8a9bd9),
                    fontSize: 70 * widget.cellSize / 100,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.6),
                        offset: Offset(3 * widget.cellSize / 100,
                            3 * widget.cellSize / 100),
                        blurRadius: 4 * widget.cellSize / 100,
                      ),
                    ],
                  ),
                ));
              } else {
                return Column(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Center(
                              child: Text(
                                cellData.helperValues.contains(1) ? "1" : "",
                                style: TextStyle(
                                  color:
                                      colorHelperValues(1, cellData, provider),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Center(
                              child: Text(
                                cellData.helperValues.contains(2) ? "2" : "",
                                style: TextStyle(
                                  color:
                                      colorHelperValues(2, cellData, provider),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Center(
                              child: Text(
                                cellData.helperValues.contains(3) ? "3" : "",
                                style: TextStyle(
                                  color:
                                      colorHelperValues(3, cellData, provider),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Center(
                              child: Text(
                                cellData.helperValues.contains(4) ? "4" : "",
                                style: TextStyle(
                                  color:
                                      colorHelperValues(4, cellData, provider),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Center(
                              child: Text(
                                cellData.helperValues.contains(5) ? "5" : "",
                                style: TextStyle(
                                  color:
                                      colorHelperValues(5, cellData, provider),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Center(
                              child: Text(
                                cellData.helperValues.contains(6) ? "6" : "",
                                style: TextStyle(
                                  color:
                                      colorHelperValues(6, cellData, provider),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Center(
                              child: Text(
                                cellData.helperValues.contains(7) ? "7" : "",
                                style: TextStyle(
                                  color:
                                      colorHelperValues(7, cellData, provider),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Center(
                              child: Text(
                                cellData.helperValues.contains(8) ? "8" : "",
                                style: TextStyle(
                                  color:
                                      colorHelperValues(8, cellData, provider),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Center(
                              child: Text(
                                cellData.helperValues.contains(9) ? "9" : "",
                                style: TextStyle(
                                  color:
                                      colorHelperValues(9, cellData, provider),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  Color colorValues(
      int value, BoardStateCell cell, BoardStateProvider provider) {
    var otherCellsInRowOrCol = provider.currentBoardState.cells
        .where((el) => el != cell && (el.col == cell.col || el.row == cell.row))
        .toList();

    var isInUse = otherCellsInRowOrCol.any((el) => el.value == value);

    if (isInUse) return Colors.red;

    var isPartOfCompletedFailureStr8te = false;

    var horIsUnCompleted =
        cell.horizontalStr8te.any((element) => element.value == 0);

    if (!horIsUnCompleted) {
      var valueList = cell.horizontalStr8te.map((e) => e.value).toList();
      var smallest = valueList.reduce(min);
      var biggest = valueList.reduce(max);
      for (var i = smallest; i < biggest; i++) {
        if (!valueList.contains(i)) {
          isPartOfCompletedFailureStr8te = true;
          break;
        }
      }
    }

    var vertIsUnCompleted =
        cell.verticalStr8te.any((element) => element.value == 0);

    if (!vertIsUnCompleted) {
      var valueList = cell.verticalStr8te.map((e) => e.value).toList();
      var smallest = valueList.reduce(min);
      var biggest = valueList.reduce(max);
      for (var i = smallest; i < biggest; i++) {
        if (!valueList.contains(i)) {
          isPartOfCompletedFailureStr8te = true;
          break;
        }
      }
    }

    if (isPartOfCompletedFailureStr8te) return Colors.orange;

    return Colors.white;
  }

  Color colorHelperValues(
      int value, BoardStateCell cell, BoardStateProvider provider) {
    var otherCellsInRowOrCol = provider.currentBoardState.cells
        .where((el) => el != cell && (el.col == cell.col || el.row == cell.row))
        .toList();

    var isInUse = otherCellsInRowOrCol.any((el) => el.value == value);

    return isInUse ? Colors.red : Colors.white;
  }
}
