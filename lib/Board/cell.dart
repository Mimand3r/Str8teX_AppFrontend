// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:str8tex_frontend/Board/board_state.dart';

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
    final cellData = context.select((BoardStateProvider p) => p.boardState.cells
        .firstWhere((element) => element.index == widget.index));

    return Container(
      width: widget.cellSize,
      height: widget.cellSize,
      decoration: BoxDecoration(
          color: const Color(0xFF1b2136),
          borderRadius: BorderRadius.circular(10 * widget.cellSize / 100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              blurRadius: 2 * widget.cellSize / 100,
              offset:
                  Offset(2 * widget.cellSize / 100, 3 * widget.cellSize / 100),
            )
          ]),
      child: Center(
        child: Container(
          width: 80 * widget.cellSize / 100,
          height: 80 * widget.cellSize / 100,
          decoration: BoxDecoration(
            color: const Color(0xFF35426b),
            borderRadius: BorderRadius.circular(2 * widget.cellSize / 100),
          ),
          child: Center(
              child: Text(
            cellData.value > 0 ? cellData.value.toString() : "",
            style: TextStyle(
              color: const Color(0xFF8a9bd9),
              fontSize: 70 * widget.cellSize / 100,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: Offset(
                      3 * widget.cellSize / 100, 3 * widget.cellSize / 100),
                  blurRadius: 4 * widget.cellSize / 100,
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
