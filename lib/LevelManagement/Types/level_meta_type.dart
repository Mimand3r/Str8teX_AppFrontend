// ignore_for_file: public_member_api_docs, sort_constructors_first
class LevelMetaType {
  String levelIdentifier;
  String levelDisplayName;
  Status status;
  int size;
  int time; // only relevant if inprogress or finished
  LevelMetaType({
    required this.levelIdentifier,
    required this.levelDisplayName,
    required this.status,
    required this.size,
    required this.time,
  });
}

enum Status { unstarted, inProgress, finished }
