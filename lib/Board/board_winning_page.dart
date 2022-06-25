import 'package:flutter/material.dart';

class BoardWinningScreen extends StatefulWidget {
  const BoardWinningScreen({Key? key}) : super(key: key);

  @override
  State<BoardWinningScreen> createState() => _BoardWinningScreenState();
}

class _BoardWinningScreenState extends State<BoardWinningScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("you won"),
          const SizedBox(height: 100),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Card(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("Go Back"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
