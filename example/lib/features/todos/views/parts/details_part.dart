import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loco_example/features/todos/events/todos_event.dart';
import 'package:loco_example/features/todos/models/todo.dart';
import 'package:loco_example/features/todos/state/todos_state.dart';
import 'package:loco_example/keys.dart';
import 'package:loco_flutter/loco_flutter.dart';
import 'package:todos_app_core/todos_app_core.dart';

class EditTodoButtonPressedEvent {
  final Todo todo;
  EditTodoButtonPressedEvent({
    this.todo,
  });
}

class DetailsViewProps extends ViewProps {
  final String id;
  DetailsViewProps({
    Key key,
    @required this.id,
  }) : super(key: key ?? LocoExampleKeys.todoDetailsScreen);
}

class DetailsView extends View<DetailsViewProps> {
  DetailsView(DetailsViewProps props) : super(props);

  @override
  Widget build(BuildContext context) {
    return buildStates<TodosState, DetailsView>(
      (BuildContext context) => {
        TodosLoadedState: (TodosLoadedState state) {
          final todo = state.todos
              .firstWhere((todo) => todo.id == props.id, orElse: () => null);
          final localizations = ArchSampleLocalizations.of(context);
          final textTheme = Theme.of(context).textTheme;

          return Scaffold(
            appBar: AppBar(
              title: Text(localizations.todoDetails),
              actions: [
                IconButton(
                  tooltip: localizations.deleteTodo,
                  key: LocoExampleKeys.deleteTodoButton,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    dispatch(DeleteTodoEvent(todo));
                    // This pop should also be taken out.
                    Navigator.pop(context, todo);
                  },
                )
              ],
            ),
            body: todo == null
                ? Container()
                // ? Container(key: BlocLibraryKeys.emptyDetailsContainer)
                : Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Checkbox(
                                  // key: BlocLibraryKeys.detailsScreenCheckBox,
                                  value: todo.complete,
                                  onChanged: (_) {
                                    dispatch(
                                      UpdateTodoEvent(
                                        todo.copyWith(complete: !todo.complete),
                                      ),
                                    );
                                  }),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: '${todo.id}__heroTag',
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(
                                        top: 8.0,
                                        bottom: 16.0,
                                      ),
                                      child: Text(
                                        todo.task,
                                        key:
                                            LocoExampleKeys.detailsTodoItemTask,
                                        style: textTheme.headline,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    todo.note,
                                    key: LocoExampleKeys.detailsTodoItemNote,
                                    style: textTheme.subhead,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            floatingActionButton: FloatingActionButton(
              key: LocoExampleKeys.editTodoFab,
              tooltip: localizations.editTodo,
              child: Icon(Icons.edit),
              onPressed: todo == null
                  ? null
                  : () => dispatch(EditTodoButtonPressedEvent(todo: todo)),
            ),
          );
        },
      },
    );
  }
}
