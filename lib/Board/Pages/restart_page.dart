import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:str8tex_frontend/LevelManagement/level_manager_provider.dart';

import '../../LevelManagement/Types/meta_data_type.dart';

class RestartPage extends StatefulWidget {
  const RestartPage({Key? key, required this.metaData}) : super(key: key);
  final MetaDataType metaData;

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
          Text(
              "Du hast das Level bereits abgeschlossen. Du hast dafür ${widget.metaData.time.toString()} sekunden gebraucht."),
          const SizedBox(height: 100),
          GestureDetector(
            onTap: () => context
                .read<LevelManagerProvider>()
                .writeLevelGotRestartedToDB(widget.metaData.levelIdentifier),
            child: const Card(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("Restart"),
              ),
            ),
          ),
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
