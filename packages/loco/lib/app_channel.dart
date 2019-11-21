import 'channel.dart';

class AppChannel {
  AppChannel._();
  static Channel _instance;
  static Channel get instance => _instance ??= Channel();
}
