import 'dart:convert';

class ClusterType {
  late int index;
  late String name;
  late List<String> level;

  static List<ClusterType> fromClusterFile(String rawStringList) {
    var map = json.decode(rawStringList) as List<dynamic>;
    var newObjects = map
        .map((x) => ClusterType()
          ..index = x["index"]
          ..name = x["name"]
          ..level = List<String>.from(x["level"]))
        .toList();
    return newObjects;
  }
}
