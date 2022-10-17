// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:str8tex_frontend/Board/Pages/IngamePageHelpers/BoardSmartCell.dart';

class IngamePage extends StatefulWidget {
  final int size;

  const IngamePage({Key? key, this.size = 9}) : super(key: key);

  @override
  State<IngamePage> createState() => _IngamePageState();
}

class _IngamePageState extends State<IngamePage> {
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
      shrinkWrap: true,
      children: List.generate(
        widget.size * widget.size,
        (index) => BoardSmartCell(
          cellSize: cellSize as double,
          index: index,
        ),
      ),
    );
  }
}
