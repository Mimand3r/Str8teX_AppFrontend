// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:str8tex_frontend/Board/cell.dart' show Cell;

class Board extends StatefulWidget {
  final int size;

  const Board({Key? key, this.size = 9}) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  void didChangeDependencies() {
    var deviceWidth = MediaQuery.of(context).size.width;
    cellSize = deviceWidth / widget.size;
    super.didChangeDependencies();
  }

  double? cellSize;

  @override
  Widget build(BuildContext context) {
    if (cellSize == null) return Container();

    return GridView.count(
      crossAxisCount: widget.size,
      children: List.generate(
        widget.size * widget.size,
        (index) => Cell(
          cellSize: cellSize as double,
          index: index,
        ),
      ),
    );
  }
}
