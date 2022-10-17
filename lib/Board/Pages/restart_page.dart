import 'package:flutter/material.dart';

class RestartPage extends StatefulWidget {
  const RestartPage({Key? key}) : super(key: key);

  @override
  State<RestartPage> createState() => _RestartPageState();
}

class _RestartPageState extends State<RestartPage> {
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
