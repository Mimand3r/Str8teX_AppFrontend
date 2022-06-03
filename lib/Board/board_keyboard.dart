import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:str8tex_frontend/Board/board_state.dart';

class BoardKeyboard extends StatefulWidget {
  const BoardKeyboard({Key? key}) : super(key: key);

  @override
  State<BoardKeyboard> createState() => _BoardKeyboardState();
}

class _BoardKeyboardState extends State<BoardKeyboard> {
  final numbers = List<int>.generate(9, (i) => i + 1);

  @override
  void didChangeDependencies() {
    var deviceWidth = MediaQuery.of(context).size.width;
    cellSize = deviceWidth / 9;
    super.didChangeDependencies();
  }

  double? cellSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: numbers.map<Widget>((e) {
            return Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: GestureDetector(
                onTap: () {
                  context.read<BoardStateProvider>().toggleHelperValue(e);
                },
                onLongPress: () {
                  context.read<BoardStateProvider>().toggleValue(e);
                },
                child: Container(
                  width: cellSize,
                  height: cellSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(255, 28, 36, 61),
                  ),
                  child: Center(
                    child: Text(
                      e.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 28, 36, 61),
              ),
              child: const Center(
                child: Text(
                  "undo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.read<BoardStateProvider>().clearActiveCell();
              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 28, 36, 61),
                ),
                child: const Center(
                  child: Text(
                    "clear",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 28, 36, 61),
              ),
              child: const Center(
                child: Text(
                  "redo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
