import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loco_example/features/todos/events/todos_event.dart';
import 'package:loco_example/features/todos/models/extra_action.dart';
import 'package:loco_example/features/todos/state/todos_state.dart';
import 'package:loco_example/keys.dart';
import 'package:loco_flutter/loco_flutter.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../home_view.dart';

class ExtraActionsPart extends ViewPart {
  final name = 'extra-actions';

  ExtraActionsPart({Key key}) : super(key: LocoExampleKeys.extraActionsButton);

  @override
  Widget build(BuildContext context) {
    return buildStates<TodosState, HomeView>(
      (BuildContext context) => {
        TodosLoadedState: (TodosLoadedState state) {
          final allComplete = state.todos.every((todo) => todo.complete);
          final dispatch = ViewDispatcher.of<HomeView>(context);
          final _ = ArchSampleLocalizations.of(context);

          return PopupMenuButton<ExtraAction>(
            // key: BlocLibraryKeys.extraActionsPopupMenuButton,
            onSelected: (action) {
              switch (action) {
                case ExtraAction.clearCompleted:
                  dispatch(ClearCompletedEvent());
                  break;
                case ExtraAction.toggleAllComplete:
                  dispatch(ToggleAllEvent());
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
              PopupMenuItem<ExtraAction>(
                key: LocoExampleKeys.toggleAll,
                value: ExtraAction.toggleAllComplete,
                child: Text(
                  allComplete ? _.markAllIncomplete : _.markAllComplete,
                ),
              ),
              PopupMenuItem<ExtraAction>(
                key: LocoExampleKeys.clearCompleted,
                value: ExtraAction.clearCompleted,
                child: Text(
                  _.clearCompleted,
                ),
              ),
            ],
          );
        },
      },
      orElse: (_) {
        return Container();
        // return Container(key: BlocLibraryKeys.extraActionsEmptyContainer);
      },
    );
  }
}
