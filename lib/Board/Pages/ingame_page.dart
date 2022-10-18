// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:str8tex_frontend/Board/Pages/IngamePageHelpers/BoardSmartCell.dart';
import 'package:str8tex_frontend/LevelManagement/Types/meta_data_type.dart';
import '../../LevelManagement/level_manager_provider.dart';
import '../board_state_provider.dart';
import 'IngamePageHelpers/board_keyboard.dart';

class IngamePage extends StatefulWidget {
  final int size;
  final MetaDataType metaData;

  const IngamePage({Key? key, this.size = 9, required this.metaData})
      : super(key: key);

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

  @override
  void initState() {
    super.initState();
    context
        .read<LevelManagerProvider>()
        .loadFullLevelData(widget.metaData.levelIdentifier)
        .then((databaseData) {
      context
          .read<BoardStateProvider>()
          .loadBoard(databaseData, context)
          .then((_) {
        setState(() => wasLoaded = true);
      });
    });
  }

  bool wasLoaded = false;
  double? cellSize;

  @override
  Widget build(BuildContext context) {
    if (cellSize == null) return Container();
    if (!wasLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(context.watch<BoardStateProvider>().time.toString()),
        GridView.count(
          crossAxisCount: widget.size,
          shrinkWrap: true,
          children: List.generate(
            widget.size * widget.size,
            (index) => BoardSmartCell(
              cellSize: cellSize as double,
              index: index,
            ),
          ),
        ),
        const BoardKeyboard(),
      ],
    );
  }
}
