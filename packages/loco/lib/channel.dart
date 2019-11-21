import 'event_bus.dart';
import 'state_controller.dart';

class Channel {
  final input = EventBus();
  final output = StateController();

  Stream<T> on<T>() {
    return input.on<T>();
  }

  CancelSubscription onEvent<T>(Object target, Function(T event) handler) {
    return input.onEvent<T>(target, handler);
  }

  void onState<S>(Object target, Function(S) handler) {
    return output.onState<S>(target, handler);
  }

  void dispatch(event) {
    input.emit(event);
  }

  void dispose() {
    input.dispose();
    output.dispose();
  }
}
