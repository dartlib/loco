import 'package:flutter/widgets.dart';
import 'package:loco/loco.dart';
import 'package:loco_flutter/loco_flutter.dart';
import 'package:loco_flutter/widgets/common/view_props.dart';

import 'widgets/view_base.dart';
import 'widgets/view_builder.dart';

/// A views container contains a set of views which logically belong together
///
/// It's main property is that the views collection will use a common
/// view channel for dispatches and to set the state.
///
/// Only the registered set of views is able to communicate using this channel.
///
/// As it implements BaseLogic it has the same kind of methods as an extension.
///
/// One of the main differences being extensions use a common AppChannel.
/// whereas the Views are using their own view channel.
///
/// Views logic is nothing else than BaseLogic with a common channel.
class ViewsLogic extends BaseLogic {
  @override
  final channel = Channel();

  final _instances = <Type, dynamic>{};
  final _slots = <Type, Map<String, dynamic>>{};

  final Map<Type, dynamic> _views = {};

  /// Provides a view channel which is passed to any registered view.
  /// Use this channel to communicate with the views.
  ///
  /// You will be setting state on the view channel and the views will
  /// react accordingly by using the withState and withStates methods provided
  /// by a [View.
  ///
  /// Use channel.setState()
  ///
  /// Use channel.onEvent to listen to any dispatches from the the views.
  void registerView<T extends ViewBase>(dynamic viewFactory) {
    if (_views.containsKey(T)) {
      throw ArgumentError('View $T is already registered');
    }

    _views[T] = viewFactory;
  }

  void registerViewWithProps<T extends ViewBase, TProps extends ViewProps>(
      dynamic viewFactory) {
    if (_views.containsKey(T)) {
      throw ArgumentError('View $T is already registered');
    }

    _views[T] = viewFactory;
  }

  ViewBuilder<ViewBuilderEvent<T>> getView<T extends ViewBase>() {
    return ViewBuilder<ViewBuilderEvent<T>>(
      viewFactory: () => _getView<T>() as Widget,
      channel: channel,
    );
  }

  ViewBuilder<ViewBuilderEvent<T>>
      getViewWithProps<T extends ViewBase, TProps extends ViewProps>(
    TProps props,
  ) {
    return ViewBuilder<ViewBuilderEvent<T>>(
      viewFactory: () => _getViewWithProps<T, TProps>(props) as Widget,
      channel: channel,
    );
  }

  T _getView<T extends ViewBase>() {
    if (_views.containsKey(T)) {
      final view = _views[T]()
        ..setChannel(
          channel,
        );

      if (_slots.containsKey(T)) {
        for (MapEntry<String, dynamic> entry in _slots[T].entries) {
          if (entry.value is ViewList) {
            view.setMultiSlot(entry.key, entry.value);
          } else {
            view.setSlot(entry.key, entry.value);
          }
        }
      }

      _instances[T] = view;

      return view as T;
    }

    throw ArgumentError('View $T is not registered');
  }

  T _getViewWithProps<T extends ViewBase, TProps extends ViewProps>(
    TProps props,
  ) {
    if (_views.containsKey(T)) {
      if (props != null) {
        return _views[T](props)..setChannel(channel);
      }

      return _views[T]()..setChannel(channel);
    }

    throw ArgumentError('View $T is not registered');
  }

  T getViewList<T extends ViewList>() {
    return _getView<T>();
  }

  T getViewListWithProps<T extends ViewList, TProps extends ViewProps>(
    TProps props,
  ) {
    return _getViewWithProps<T, TProps>(props);
  }

  void setSlot<T extends ViewBase>(
    String name,
    dynamic view,
  ) {
    if (!_slots.containsKey(T)) {
      // _slots[T] = <String, ViewBase>{};
      _slots[T] = <String, dynamic>{};
    }

    _slots[T][name] = view;

    // update the last instance (if created)
    if (_instances.containsKey(T)) {
      final currentSlotView = _instances[T];

      if (view is ViewList) {
        (currentSlotView as Slots).setMultiSlot(name, view);
      } else {
        (currentSlotView as Slots).setSlot(name, view);
      }
    }
  }

  void setSlots<T extends ViewBase>(Map<String, dynamic> slots) {
    for (MapEntry<String, dynamic> entry in slots.entries) {
      setSlot<T>(entry.key, entry.value);
    }
  }

  /// Updates the slots for the containing view.
  void updateSlots<T extends ViewBase>(Map<String, dynamic> slots) {
    setSlots<T>(slots);
    channel.dispatch(ViewBuilderEvent<T>());
  }
}

/// Views mixin
///
/// Can be used to registered views with an extension.
abstract class Views {
  final views = ViewsLogic();
}
