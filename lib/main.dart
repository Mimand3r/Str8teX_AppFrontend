import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:str8tex_frontend/Board/board.dart' show Board;
import 'package:str8tex_frontend/Board/board_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BoardStateProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    if (!wasLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return const Center(
        child: Board(),
      );
    }

    // return Scaffold(body: Builder(
    //   builder: ((context) {
    //     if (!wasLoaded) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     } else {
    //       return const Center(
    //         child: Board(),
    //       );
    //     }
    //   }),
    // ));
  }
}
