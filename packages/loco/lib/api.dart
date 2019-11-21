import 'dart:async';

import 'app_channel.dart';
import 'extension.dart';

abstract class ApiEvent {}

class ApiInitializedEvent extends ApiEvent {}

class Api {
  final channel = AppChannel.instance;
  final _extensions = <Type, Extension>{};
  final _any = <Type, dynamic>{};

  Api._();
  static Api _instance;
  static Api get instance => _instance ??= Api._();

  Future<void> initialize() async {
    for (var extension in _extensions.values) {
      await extension.onInit();
    }

    channel.dispatch(ApiInitializedEvent());
  }

  void dispose() {}

  void register<T>(T instance) {
    final type = _typeOf<T>();
    if (_any.containsKey(type)) {
      throw ArgumentError(
        'Instance ${type.runtimeType} is already registered.',
      );
    }

    _any[type] = instance;
  }

  void registerExtension(Extension extension) {
    if (_extensions.containsKey(extension.runtimeType)) {
      throw ArgumentError(
        'Extension ${extension.runtimeType} is already registered.',
      );
    }

    extension.channel = channel;

    _extensions[extension.runtimeType] = extension;

    extension.onRegister();
  }

  T getExtension<T extends Extension>() {
    final type = _typeOf<T>();

    if (_extensions.containsKey(type)) {
      return _extensions[type] as T;
    }

    throw ArgumentError(
      'Extension $type is not registered.',
    );
  }

  bool hasExtension<T extends Extension>() {
    final type = _typeOf<T>();

    return _extensions.containsKey(type);
  }

  T get<T>() {
    final type = _typeOf<T>();

    if (_any.containsKey(type)) {
      return _any[type] as T;
    }

    throw ArgumentError(
      'Instance of $type is not registered.',
    );
  }

  Type _typeOf<T>() => T;
}
