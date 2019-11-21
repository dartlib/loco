import 'dart:async';

typedef CancelSubscription();

class EventBus {
  final StreamController _streamController;
  final _eventHandlerMap = <Type, List<StreamSubscription>>{};

  StreamController get streamController => _streamController;

  EventBus({bool sync = false})
      : _streamController = StreamController.broadcast(sync: sync);

  Stream<T> on<T>() {
    if (T == dynamic) {
      return streamController.stream as Stream<T>;
    } else {
      // TODO: Debugger somehow loops here many times
      return streamController.stream.where((event) => event is T).cast<T>();
    }
  }

  CancelSubscription onEvent<T>(Object target, Function(T event) handler) {
    if (!_eventHandlerMap.containsKey(target)) {
      _eventHandlerMap[target] = [];
    }

    final subscription = on<T>().listen(handler);

    _eventHandlerMap[target].add(subscription);

    return () {
      subscription.cancel();
      _eventHandlerMap[target].removeWhere((item) => item == subscription);
      if (_eventHandlerMap[target].isEmpty) {
        _eventHandlerMap.remove(target);
      }
    };
  }

  /// Remove any event handlers which have been attached by [target].
  ///
  void removeEventHandlers(Object target) {
    if (_eventHandlerMap.containsKey(target)) {
      final handlers = _eventHandlerMap[target];

      for (var handler in handlers) {
        handler.cancel();
      }

      _eventHandlerMap.remove(target);
    } else {
      throw Exception('No handlers registered for ${target.runtimeType}');
    }
  }

  /// Emits a new event on the event bus with the specified [event].
  ///
  void emit(event) {
    streamController.add(event);
  }

  /// Dispose this [EventBus].
  ///
  void dispose() {
    _streamController.close();
  }
}
