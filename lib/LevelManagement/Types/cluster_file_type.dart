import 'dart:convert';

class ClusterFileType {
  late int index;
  late String name;
  late List<String> level;

  static List<ClusterFileType> fromClusterFile(String rawStringList) {
    var map = json.decode(rawStringList) as List<dynamic>;
    var newObjects = map
        .map((x) => ClusterFileType()
          ..index = x["index"]
          ..name = x["name"]
          ..level = List<String>.from(x["level"]))
        .toList();
    return newObjects;
  }
}
