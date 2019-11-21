import 'package:rxdart/rxdart.dart';

import 'channel.dart';

abstract class OnRegister {
  /// Called when the component is registered
  /// This is the right place to setup any listeners
  void onRegister() {}
}

abstract class OnInit {
  /// Called after all components are registered
  /// This is the right place to dispatch any initial events
  Future<void> onInit() async {}
}

/// Logic component which comes with an isolated channel by default.
abstract class Logic<BaseState> extends BaseLogic<BaseState> {}

/// BaseLogic
abstract class BaseLogic<BaseState> with OnRegister, OnInit {
  Channel get channel;

  void onEvent<T>(Function(T event) handler) {
    if (T == dynamic) {
      throw ArgumentError('T must not be dynamic');
    }

    channel.input.onEvent<T>(this, handler);
  }

  /// Used to attach a handler whenever a state update for [S] occurs.
  ///
  /// ```
  ///   onState<TodosLoadedState>(_updateStats);
  /// ```
  ///
  /// Handlers will be disposed automatically by the [BaseLogic] dispose method.
  void onState<S>(Function(S state) handler) {
    channel.output.onState<S>(this, handler);
  }

  // void setState<S extends BaseState>(S state) {
  void setState<S>(S state) {
    return channel.output.setState<S>(state);
  }

  void dispatch(event) {
    channel.input.emit(event);
  }

  BehaviorSubject<S> getStateStream<S>() {
    return channel.output.getStateStream<S>();
  }

  // S getState<S extends BaseState>() {
  S getState<S>() {
    return channel.output.getCurrentState<S>();
  }

  void initState<S>(S initialValue) {
    channel.output.initState(initialValue);
  }

  void dispose() {
    channel.output.removeStateHandlers(this);
    channel.dispose();
  }
}
