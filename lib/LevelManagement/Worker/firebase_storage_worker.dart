import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Types/database_level_type.dart';
import 'sqflite_worker.dart';

class FirebaseStorageWorker {
  static Future<List<String>> fetchLevelNamesFromFirebase() async {
    var db = FirebaseFirestore.instance;
    var fileListDoc = await db.collection("file_list").doc("0").get();
    final namensListe = (((fileListDoc.data() as Map<String, dynamic>)["names"])
            as List<dynamic>)
        .cast<String>();

    return namensListe;
  }

  static Future downloadAndStoreMissingLevels(
      List<String> firebaseLevelNames, List<String> storedLevels) async {
    // Finde Namen aller Level die noch nicht auf device existieren
    final nameMissingLevels = firebaseLevelNames
        .where((element) => !storedLevels.contains(element))
        .toList();

    if (nameMissingLevels.isEmpty) return;

    // Fetch Level Data from Firebase for all missing levels
    final db = FirebaseFirestore.instance;
    final collectionRef = db.collection("str8te_x_data");
    final dataSnapshot =
        await collectionRef.where("name", whereIn: nameMissingLevels).get();

    final unstoredLevels = dataSnapshot.docs.map((doc) {
      final data = doc.data();
      return DatabaseLevelType()
        ..levelName = data["name"]
        ..emptyBoardData = data["EmptyBoard"]
        ..solvedBoardData = data["Solution"]
        ..size = data["size"];
    }).toList();

    // Store new Levels in Database
    await SQFLiteWorker.storeLevelsInDatabase(unstoredLevels);
  }
}
