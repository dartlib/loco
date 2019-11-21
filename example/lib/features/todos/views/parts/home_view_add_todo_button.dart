import 'package:flutter/material.dart';
import 'package:loco_example/features/todos/events/todos_event.dart';
import 'package:loco_example/keys.dart';
import 'package:loco_flutter/loco_flutter.dart';
import 'package:todos_app_core/todos_app_core.dart';

class HomeViewAddTodoButton extends View {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: LocoExampleKeys.addTodoFab,
      onPressed: () {
        dispatch(AddTodoButtonPressedEvent());
      },
      child: Icon(Icons.add),
      tooltip: ArchSampleLocalizations.of(context).addTodo,
    );
  }
}
