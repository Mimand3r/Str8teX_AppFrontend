import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:str8tex_frontend/Board/board_keyboard.dart';
import 'package:str8tex_frontend/Board/board.dart';
import 'package:str8tex_frontend/Board/board_state_provider.dart';
import 'package:str8tex_frontend/Board/board_winning_page.dart';
import 'package:str8tex_frontend/LevelManagement/level_manager_provider.dart';

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

    if (isSolved) return const BoardWinningScreen();

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
              Board(),
              BoardKeyboard(),
            ],
          );
        }
      }),
    );
  }
}
