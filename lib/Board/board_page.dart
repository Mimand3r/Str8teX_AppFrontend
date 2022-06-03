import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:str8tex_frontend/Board/board_keyboard.dart';
import 'package:str8tex_frontend/Board/board.dart';
import 'package:str8tex_frontend/Board/board_state.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<BoardStateProvider>()
        .loadJSONBoard()
        .then((value) => setState(() => wasLoaded = true));
  }

  bool wasLoaded = false;

  @override
  Widget build(BuildContext context) {
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
