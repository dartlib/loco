import 'package:loco/extension.dart';
import 'package:loco_example/features/todos/state/todos_state.dart';

import 'stats_state.dart';
import 'stats_view.dart';

class StatsExtension extends Extension<StatsState> {
  @override
  final String name = 'StatsExtension';

  final views = {
    StatsView,
  };

  @override
  void onRegister() {
    //TODO: make this onState<TodosState, TodosLoadedState>(..)
    onState<TodosState>(_updateStats);
  }

  void _updateStats(TodosState state) {
    if (state is TodosLoadedState) {
      int numActive =
          state.todos.where((todo) => !todo.complete).toList().length;
      int numCompleted =
          state.todos.where((todo) => todo.complete).toList().length;

      setState<StatsState>(
        StatsLoadedState(
          numActive,
          numCompleted,
        ),
      );
    }
  }
}
