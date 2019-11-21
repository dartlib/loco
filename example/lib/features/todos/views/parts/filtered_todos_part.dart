import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loco_example/features/todos/events/todos_event.dart';
import 'package:loco_example/features/todos/models/models.dart';
import 'package:loco_example/features/todos/state/filtered_todos_state.dart';
import 'package:loco_example/features/todos/widgets/delete_todo_snack_bar.dart';
import 'package:loco_example/features/todos/widgets/todo_item.dart';
import 'package:loco_example/keys.dart';
import 'package:loco_example/widgets/loading_indicator.dart';
import 'package:loco_flutter/loco_flutter.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../home_view.dart';

class TodoItemTappedEvent {
  final Todo todo;
  TodoItemTappedEvent({this.todo});
}

class FilteredTodosPart extends View {
  // Part {
  final name = 'filtered-todos';

  FilteredTodosPart([ViewProps props]) : super(props);

  @override
  Widget build(BuildContext context) {
    final localizations = ArchSampleLocalizations.of(context);

    return buildStates<FilteredTodosState, HomeView>(
      (BuildContext context) => {
        FilteredTodosLoadingState: (FilteredTodosLoadingState state) =>
            LoadingIndicator(),
        // LoadingIndicator(key: LocoExampleKeys.todosLoading),
        FilteredTodosLoadedState: (FilteredTodosLoadedState state) {
          final todos = state.filteredTodos;

          return ListView.builder(
            key: LocoExampleKeys.todoList,
            itemCount: todos.length,
            itemBuilder: (BuildContext context, int index) {
              final todo = todos[index];
              return TodoItem(
                todo: todo,
                onDismissed: (direction) {
                  dispatch(
                    DeleteTodoEvent(todo),
                  );
                  Scaffold.of(context).showSnackBar(
                    DeleteTodoSnackBar(
                      key: LocoExampleKeys.snackbar,
                      todo: todo,
                      onUndo: () => dispatch(
                        AddTodoEvent(todo),
                      ),
                      localizations: localizations,
                    ),
                  );
                },
                onTap: () async {
                  dispatch(
                    TodoItemTappedEvent(todo: todo),
                  );
                  // The "problem" here is that DetailsView is not registered as a view
                  // So here a dispatch is needed and we properly get the view
                  // perhaps I should also make it impossible to directly instantiate
                  // a View widget. This way it cannot be instantiated directly
                  // further separating it from normal widgets
                  // Dus..
                  // deze route moet worden geregistreerd
                  // not sure how removeTodo is established.
                  // something with willPop I believe
                  // or is the snackbar just never shown.
                  /*
                  final removedTodo = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) {
                      return DetailsView(
                        DetailsViewProps(id: todo.id),
                      );
                    }),
                  );
                  if (removedTodo != null) {
                    Scaffold.of(context).showSnackBar(
                      DeleteTodoSnackBar(
                        key: LocoExampleKeys.snackbar,
                        todo: todo,
                        onUndo: () => dispatch(
                          AddTodoEvent(todo),
                        ),
                        localizations: localizations,
                      ),
                    );
                  }
                   */
                },
                onCheckboxChanged: (_) {
                  dispatch(
                    UpdateTodoEvent(todo.copyWith(
                      complete: !todo.complete,
                    )),
                  );
                },
              );
            },
          );
        },
      },
      orElse: (_) {
        return Container();
        // Container(key: BlocLibraryKeys.filteredTodosEmptyContainer);
      },
    );
  }
}
