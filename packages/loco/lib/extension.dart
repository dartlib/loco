import 'channel.dart';
import 'logic.dart';

abstract class Extension<State> extends BaseLogic<State> {
  String get name;
  Channel channel;
}
