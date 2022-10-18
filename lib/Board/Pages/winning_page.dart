import 'package:flutter/material.dart';

import '../../LevelManagement/Types/meta_data_type.dart';

class WinningPage extends StatefulWidget {
  const WinningPage({Key? key, required this.metaData}) : super(key: key);
  final MetaDataType metaData;

  @override
  State<WinningPage> createState() => _WinningPageState();
}

class _WinningPageState extends State<WinningPage> {
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
