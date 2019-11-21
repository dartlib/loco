import 'package:flutter/widgets.dart';
import 'package:loco_flutter/mixins/state_builder_mixin.dart';
import 'package:loco_flutter/widgets/stateful_view.dart';

abstract class ViewState<T extends StatefulView> extends State<T>
    with StateBuilderMixin {
  get props => widget.props;

  Function onEvent<T>(Function(T event) handler) {
    return widget.onEvent(handler);
  }

  void dispatch(dynamic event) {
    widget.dispatch(event);
  }
}
