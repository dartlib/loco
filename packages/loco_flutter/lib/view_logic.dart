import 'package:loco/loco.dart';

// Not used at the moment.
class ViewLogic with OnRegister, OnInit {
  ViewLogic({
    Channel parentChannel,
  })  : assert(parentChannel != null),
        _parentChannel = parentChannel;
  final Channel _parentChannel;

  /// For the viewChannel.
  ///
  /// onState<> is used by the ViewParts and it's StateBuilder
  /// dispatch is used by the ViewParts
  /// onEvent is used internally to react to the dispatches.
  /// setState is used internally to reflect the new state for this View and it's ViewParts.
  /// So the viewChannel uses it's full functionality.
  final Channel viewChannel = Channel();

  /// Used to listen on the parent state.
  ///
  void onState<S>(Function(S state) handler) {
    _parentChannel.output.onState<S>(this, handler);
  }

  /// Dispatches an event to the parent channel
  ///
  void dispatch(event) {
    _parentChannel.dispatch(event);
  }

  /// Not used directly but provided to the View(Widget) ///
  void viewDispatcher(event) {
    viewChannel.dispatch(event);
  }
}
