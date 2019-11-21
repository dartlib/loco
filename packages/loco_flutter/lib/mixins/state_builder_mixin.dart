import 'package:flutter/widgets.dart';
import 'package:loco_flutter/widgets/common/listen_callback.dart';
import 'package:loco_flutter/widgets/state_builder.dart';
import 'package:loco_flutter/widgets/states_builder.dart';
import 'package:loco_flutter/widgets/view.dart';

abstract class StateBuilderMixin {
  // should become buildState<ViewLogic, ViewState>(..)
  Widget buildState<S, V extends View>({
    ListenCallback onListen,
    AsyncWidgetBuilder<S> builder,
  }) {
    return StateBuilder<S, V>(
      builder: builder,
      onListen: onListen,
    );
  }

  // should become buildStates<ViewLogic, ViewState>(..)
  Widget buildStates<S, V extends View>(
    Map<Type, dynamic> Function(BuildContext context) builder, {
    ListenCallback onListen,
    Function(BuildContext context) orElse,
  }) {
    return StatesBuilder<S, V>(
      builder,
      onListen: onListen,
      orElse: orElse,
    );
  }
}
