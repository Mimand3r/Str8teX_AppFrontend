import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'LevelManagement/level_manager_provider.dart';

class StartupLoadingModule {
  static Future loadAllModules(BuildContext context) async {
    await context.read<LevelManagerProvider>().initializeDatabaseOnAppstart();
  }
}
