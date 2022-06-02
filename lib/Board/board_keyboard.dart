import 'package:flutter/material.dart';

class BoardKeyboard extends StatefulWidget {
  const BoardKeyboard({Key? key}) : super(key: key);

  @override
  State<BoardKeyboard> createState() => _BoardKeyboardState();
}

class _BoardKeyboardState extends State<BoardKeyboard> {
  final numbers = List<int>.generate(9, (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: numbers.map<Widget>((e) {
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.green,
          ),
          child: Center(
            child: Text(e.toString()),
          ),
        );
      }).toList(),
    );
  }
}
