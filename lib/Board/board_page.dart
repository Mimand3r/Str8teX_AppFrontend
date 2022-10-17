import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:str8tex_frontend/Board/Pages/IngamePageHelpers/board_keyboard.dart';
import 'package:str8tex_frontend/Board/Pages/ingame_page.dart';
import 'package:str8tex_frontend/Board/board_state_provider.dart';
import 'package:str8tex_frontend/Board/Pages/winning_page.dart';
import 'package:str8tex_frontend/LevelManagement/level_manager_provider.dart';

import 'Pages/IngamePageHelpers/board_keyboard.dart';

class BoardPage extends StatefulWidget {
  final String levelName;

  const BoardPage({Key? key, required this.levelName}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<LevelManagerProvider>()
        .loadLevelData(widget.levelName)
        .then((databaseData) {
      context.read<BoardStateProvider>().loadBoard(databaseData).then((_) {
        setState(() => wasLoaded = true);
      });
    });
  }

  bool wasLoaded = false;

  @override
  Widget build(BuildContext context) {
    var isSolved =
        context.select<BoardStateProvider, bool>((value) => value.isFinished);

    if (isSolved) return const WinningPage();

    return Builder(
      builder: ((context) {
        if (!wasLoaded) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              IngamePage(),
              BoardKeyboard(),
            ],
          );
        }
      }),
    );
  }
}
