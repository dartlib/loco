import 'package:meta/meta.dart';

class Completable<T> {
  final T event;
  final Function() _onComplete;
  bool _isCompleted = false;
  Completable(
    this.event, {
    @required onComplete,
  })  : assert(onComplete != null),
        _onComplete = onComplete;

  complete() {
    if (_isCompleted) {
      throw ArgumentError('Event $T has already been completed');
    }
    _onComplete();
    _isCompleted = true;
  }
}
