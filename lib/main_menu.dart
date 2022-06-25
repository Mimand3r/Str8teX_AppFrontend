import 'package:flutter/material.dart';
import 'package:str8tex_frontend/Advertisement/adv_testing_page.dart';
import 'package:str8tex_frontend/LevelManagement/level_page.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 70),
          const Text(
            "Str8ts X",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 150),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (c) =>
                      const Scaffold(body: SafeArea(child: LevelPage()))));
            },
            child: Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                child: Text("Starten"),
              ),
            ),
          ),
          const SizedBox(height: 150),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (c) => const Scaffold(
                      body: SafeArea(child: WerbeTestingPage()))));
            },
            child: Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                child: Text("Werbung Testen"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
