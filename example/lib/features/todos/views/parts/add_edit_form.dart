import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loco/loco.dart';
import 'package:loco_example/features/todos/events/add_edit_event.dart';
import 'package:loco_example/features/todos/models/todo.dart';
import 'package:loco_example/keys.dart';
import 'package:loco_flutter/loco_flutter.dart';
import 'package:todos_app_core/todos_app_core.dart';

class SaveAddEditFormEvent {}

class AddEditFormProps extends ViewProps {
  final bool isEditing;
  final Todo todo;
  AddEditFormProps({
    Key key,
    @required this.isEditing,
    this.todo,
  }) : super(key: key ?? Key('${LocoExampleKeys.addTodoScreen}_form'));
}

class AddEditForm extends StatefulView<AddEditFormProps> {
  AddEditForm(AddEditFormProps props) : super(props);

  @override
  _AddEditFormState createState() => _AddEditFormState();
}

class _AddEditFormState extends ViewState<AddEditForm> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _task;
  String _note;
  CancelSubscription _cancelSaveAddEditFormEvent;

  @override
  void initState() {
    _cancelSaveAddEditFormEvent = onEvent<SaveAddEditFormEvent>(_save);
    super.initState();
  }

  @override
  void dispose() {
    _cancelSaveAddEditFormEvent();

    super.dispose();
  }

  _save(_) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      dispatch(
        FormSavedEvent(
          task: _task,
          note: _note,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _ = ArchSampleLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              initialValue: props.isEditing ? props.todo.task : '',
              key: LocoExampleKeys.taskField,
              autofocus: !props.isEditing,
              style: textTheme.headline,
              decoration: InputDecoration(
                hintText: _.newTodoHint,
              ),
              validator: (val) {
                return val.trim().isEmpty ? _.emptyTodoError : null;
              },
              onSaved: (value) => _task = value,
            ),
            TextFormField(
              initialValue: props.isEditing ? props.todo.note : '',
              key: LocoExampleKeys.noteField,
              maxLines: 10,
              style: textTheme.subhead,
              decoration: InputDecoration(
                hintText: _.notesHint,
              ),
              onSaved: (value) => _note = value,
            )
          ],
        ),
      ),
    );
  }
}
