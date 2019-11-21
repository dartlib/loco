import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:loco/loco.dart';
import 'package:meta/meta.dart';

import 'common/listen_callback.dart';
import 'view.dart';

class StateBuilder<T, V extends View> extends StatefulWidget {
  const StateBuilder({
    @required this.builder,
    this.onListen,
    Key key,
  })  : assert(builder != null),
        super(key: key);

  final ListenCallback onListen;
  final AsyncWidgetBuilder<T> builder;

  AsyncSnapshot<T> initial() {
    return AsyncSnapshot<T>.withData(ConnectionState.none, null);
  }

  AsyncSnapshot<T> afterConnected(AsyncSnapshot<T> current, Channel channel) {
    if (onListen != null) {
      onListen(channel);
    }
    return current.inState(ConnectionState.waiting);
  }

  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) {
    return AsyncSnapshot<T>.withData(ConnectionState.active, data);
  }

  AsyncSnapshot<T> afterError(AsyncSnapshot<T> current, Object error) {
    return AsyncSnapshot<T>.withError(ConnectionState.active, error);
  }

  AsyncSnapshot<T> afterDone(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.done);

  AsyncSnapshot<T> afterDisconnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.none);

  Widget build(BuildContext context, AsyncSnapshot<T> currentSummary) =>
      builder(context, currentSummary);

  @override
  State<StateBuilder<T, V>> createState() => _StateBuilderState<T, V>();
}

class _StateBuilderState<T, V extends View> extends State<StateBuilder<T, V>> {
  StreamSubscription<T> _subscription;
  AsyncSnapshot<T> _state;
  Stream<T> _stream;
  Channel _channel;

  @override
  void initState() {
    super.initState();
    _state = widget.initial();
    _channel = View.of<V>(context).channel;
    _subscribe();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, _state);

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  Future<void> _subscribe() async {
    // if (widget.channel != null) {
    // if (_channel != null) {
    // _stream = widget.channel.output.getStateStream<T>();
    _stream = _channel.output.getStateStream<T>();

    _subscription = _stream.listen((T data) {
      // do not build if there is no initialState
      if (data != null) {
        setState(() {
          _state = widget.afterData(_state, data);
        });
      }
    }, onError: (Object error) {
      setState(() {
        _state = widget.afterError(_state, error);
      });
    }, onDone: () {
      setState(() {
        _state = widget.afterDone(_state);
      });
    });

    _state = widget.afterConnected(_state, _channel);
    //}
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }
}
