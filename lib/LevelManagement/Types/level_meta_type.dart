// ignore_for_file: public_member_api_docs, sort_constructors_first
class LevelMetaType {
  String levelName;
  int currentTime;
  int rekordTime;
  late LevelMetaTypeStatus status;
  int size;
  LevelMetaType({
    required this.levelName,
    required this.currentTime,
    required this.rekordTime,
    required this.size,
  }) {
    if (currentTime == 0 && rekordTime == 0) {
      status = LevelMetaTypeStatus.unstarted;
    } else if (currentTime == 0) {
      status = LevelMetaTypeStatus.finished;
    } else if (rekordTime == 0) {
      status = LevelMetaTypeStatus.inProgress;
    } else {
      status = LevelMetaTypeStatus.restarted;
    }
  }
}

enum LevelMetaTypeStatus { unstarted, inProgress, finished, restarted }
