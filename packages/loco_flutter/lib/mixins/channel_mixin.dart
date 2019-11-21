import 'package:loco/loco.dart';

import '../view_dependencies.dart';

abstract class ChannelMixin {
  final _viewDependencies = ViewDependencies();

  Channel get channel => _viewDependencies.channel;

  Function onEvent<T>(Function(T event) handler) {
    return channel.input.onEvent(this, handler);
  }

  void dispatch(dynamic event) {
    channel.input.emit(event);
  }

  void setChannel(Channel channel) {
    _viewDependencies.channel = channel;
  }
}
