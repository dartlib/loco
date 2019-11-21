import 'package:flutter/material.dart';
import 'package:loco/loco.dart';
import 'package:loco_example/extensions/material_ui/material_ui_extension.dart';
import 'package:loco_example/features/stats/stats_extension.dart';
import 'package:loco_example/features/todos/todos_extension.dart';
import 'package:loco_example/localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

import 'features/todos/todos_views.dart';
import 'repository/src/file_storage.dart';
import 'repository/src/repository.dart';

void main() {
  Api.instance
    ..register<TodosRepository>(
      TodosRepositoryFlutter(
        fileStorage: const FileStorage(
          '__flutter_bloc_app__',
          getApplicationDocumentsDirectory,
        ),
      ),
    )
    ..registerExtension(
      MaterialUIExtension(
        MaterialUIExtensionOptions(
          title: 'Todo APP',
          localizationsDelegates: [
            ArchSampleLocalizationsDelegate(),
            LocoExampleLocalizationsDelegate(),
          ],
          theme: ThemeData(
            brightness: Brightness.dark,
          ),
        ),
      ),
    )
    ..registerExtension(StatsExtension())
    ..registerExtension(TodosExtension())
    ..registerExtension(TodosViews())
    ..initialize().catchError(
      (error) {
        print(error);
      },
    );
}
