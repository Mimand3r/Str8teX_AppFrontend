import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:str8tex_frontend/Board/board_page.dart';
import 'package:str8tex_frontend/LevelManagement/level_manager_provider.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({Key? key}) : super(key: key);

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  @override
  Widget build(BuildContext context) {
    var levels = context.watch<LevelManagerProvider>().levelMetaData;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(15.0),
            children: levels
                .map((e) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              body: BoardPage(levelName: e.levelName),
                            ),
                          ),
                        );
                      },
                      child: Card(
                          elevation: 8.0,
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.levelName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Text("Size: ${e.size}", style: smallText()),
                                    const SizedBox(width: 5),
                                    Text(
                                      "IsSolved: ${e.isSolved.toString()}",
                                      style: smallText(),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  TextStyle smallText() => const TextStyle(
        fontSize: 10,
      );
}
