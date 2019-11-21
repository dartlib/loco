import 'package:flutter/material.dart';
import 'package:loco_flutter/loco_flutter.dart';
import 'package:todos_app_core/todos_app_core.dart';

class AddEditScreen extends StatefulView<ViewProps> with Slots {
  AddEditScreen([ViewProps props]) : super(props);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends ViewState<AddEditScreen> {
  @override
  Widget build(BuildContext context) {
    final _ = ArchSampleLocalizations.of(context);

    // the slot names can then become generic.
    return Scaffold(
      appBar: AppBar(
        title: widget.slot('add-edit-form-title'),
      ),
      body: widget.slot('add-edit-form'),
      floatingActionButton: widget.slot('add-edit-form-button'),
    );
  }
}
