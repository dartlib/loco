import 'dart:async';

import 'package:rxdart/subjects.dart';

class StateController {
  final _stateMap = <Type, BehaviorSubject>{};
  final _stateHandlerMap = <Type, List<StreamSubscription>>{};

  /// Initializes the state either when first set or upon first retrieval.
  ///
  Type initState<S>([S initialValue]) {
    final type = _typeOf<S>();
    if (!_stateMap.containsKey(type)) {
      if (initialValue != null) {
        _stateMap[type] = BehaviorSubject<S>.seeded(initialValue);
      } else {
        _stateMap[type] = BehaviorSubject<S>();
      }
    }

    return type;
  }

  /// Used to attach a handler whenever a state change occurs.
  ///
  /// ```
  ///   onState<TodosLoadedState>(this, _updateStats);
  /// ```
  ///
  /// It's important to always run removeStateHandlers(this) on dispose.
  void onState<S>(Object target, Function(S) handler) {
    if (!_stateHandlerMap.containsKey(target.runtimeType)) {
      _stateHandlerMap[target.runtimeType] = [];
    }

    _stateHandlerMap[target.runtimeType].add(
      getStateStream<S>().listen(handler),
    );
  }

  /// Remove any state handlers which have been attached by [target].
  ///
  void removeStateHandlers(Object target) {
    if (_stateHandlerMap.containsKey(target.runtimeType)) {
      final handlers = _stateHandlerMap[target.runtimeType];
      for (var handler in handlers) {
        handler.cancel();
      }
    } else {
      throw Exception('No handlers registered for ${target.runtimeType}');
    }
  }

  /// Update or create a new state on the stateful event bus with the specified [state].
  ///
  void setState<S>(S state) {
    final type = initState<S>();
    _stateMap[type].add(state);
  }

  /// Retrieves a state from the stateful event bus of [Type] [S]
  BehaviorSubject<S> getStateStream<S>() {
    final type = initState<S>();

    return _stateMap[type] as BehaviorSubject<S>;
  }

  S getCurrentState<S>() {
    final type = _typeOf<S>();
    if (!_stateMap.containsKey(type)) {
      throw ArgumentError('No such state $type');
    }

    final stream = _stateMap[type] as BehaviorSubject<S>;

    return stream.value;
  }

  Type _typeOf<T>() => T;

  void dispose() {
    for (var controller in _stateMap.values) {
      controller.close();
    }
  }
}
