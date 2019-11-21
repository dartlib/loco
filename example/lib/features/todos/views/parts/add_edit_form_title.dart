import 'package:flutter/widgets.dart';
import 'package:loco_flutter/loco_flutter.dart';
import 'package:todos_app_core/todos_app_core.dart';

class AddEditFormTitleProps extends ViewProps {
  final bool isEditing;
  AddEditFormTitleProps({
    Key key,
    @required this.isEditing,
  }) : super(key: key);
}

class AddEditFormTitle extends View {
  final AddEditFormTitleProps props;

  AddEditFormTitle(this.props) : super(props);

  @override
  Widget build(BuildContext context) {
    final _ = ArchSampleLocalizations.of(context);

    return Text(
      props.isEditing ? _.editTodo : _.addTodo,
    );
  }
}
