import 'package:flutter/material.dart';
import 'package:loco_example/features/todos/models/models.dart';
import 'package:loco_example/keys.dart';
import 'package:loco_flutter/loco_flutter.dart';
import 'package:todos_app_core/todos_app_core.dart';

class AddEditFormButtonPressedEvent {}

class AddEditFormButtonProps extends ViewProps {
  final bool isEditing;
  final Todo todo;
  AddEditFormButtonProps({
    Key key,
    @required this.isEditing,
    this.todo,
  }) : super(key: key ?? LocoExampleKeys.addTodoScreen);
}

class AddEditFormButton extends View {
  final AddEditFormButtonProps props;
  AddEditFormButton(this.props) : super(props);
  @override
  Widget build(BuildContext context) {
    final _ = ArchSampleLocalizations.of(context);

    return FloatingActionButton(
      key: props.isEditing
          ? LocoExampleKeys.saveTodoFab
          : LocoExampleKeys.saveNewTodo,
      tooltip: props.isEditing ? _.saveChanges : _.addTodo,
      child: Icon(props.isEditing ? Icons.check : Icons.add),
      onPressed: () {
        dispatch(AddEditFormButtonPressedEvent());
      },
    );
  }
}
