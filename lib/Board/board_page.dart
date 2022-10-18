import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:str8tex_frontend/Board/Pages/IngamePageHelpers/board_keyboard.dart';
import 'package:str8tex_frontend/Board/Pages/ingame_page.dart';
import 'package:str8tex_frontend/Board/Pages/restart_page.dart';
import 'package:str8tex_frontend/Board/board_state_provider.dart';
import 'package:str8tex_frontend/Board/Pages/winning_page.dart';
import 'package:str8tex_frontend/LevelManagement/Types/meta_data_type.dart';
import 'package:str8tex_frontend/LevelManagement/level_manager_provider.dart';

import 'Pages/IngamePageHelpers/board_keyboard.dart';

class BoardPage extends StatefulWidget {
  final String levelName;

  const BoardPage({Key? key, required this.levelName}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  // Listen to MetaData des gestarteten Levels
  // Ist das Level bereits Finished, so zeige restart Screen
  // ansonsten leite zum ProgressScreen weiter und warte auf winning condition

  @override
  void initState() {
    super.initState();
    firstBuild = true;
  }

  // bool wasLoaded = false;

  MetaDataType? metaData;
  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    var prov = context.watch<LevelManagerProvider>();
    metaData = prov.levelMetaData
        .firstWhere((element) => element.levelIdentifier == widget.levelName);
    var isFirstBuild = firstBuild;
    firstBuild = false;

    // Kann 3 verschiedene Screens returnen, Board, Winning or Restart Screen

    if (metaData!.status != Status.finished) {
      return Scaffold(
        body: SafeArea(
          child: IngamePage(
            size: metaData!.size,
            metaData: metaData as MetaDataType,
          ),
        ),
      );
    } else {
      if (isFirstBuild) {
        return Scaffold(
          body: SafeArea(
            child: RestartPage(
              metaData: metaData as MetaDataType,
            ),
          ),
        );
      } else {
        return Scaffold(
          body: SafeArea(
            child: IngamePage(
              size: metaData!.size,
              metaData: metaData as MetaDataType,
            ),
          ),
        );
      }
    }
  }
}
