import 'package:flutter/widgets.dart';

import 'widgets/view_builder.dart';
import 'widgets/view_list.dart';

/// Slots
///
/// Enables setting and retrieving slots on a view
abstract class Slots {
  final Map<String, ViewBuilder> _slots = {};
  final Map<String, ViewList> _multiSlots = {};

  setSlot(String name, ViewBuilder view) {
    _slots[name] = view;
  }

  setMultiSlot(String name, ViewList listView) {
    _multiSlots[name] = listView;
  }

  ViewBuilder slot(String name) {
    if (_slots.containsKey(name)) {
      return _slots[name];
    }

    return null;
  }

  List<Widget> multiSlot(String name, BuildContext context) {
    if (_multiSlots.containsKey(name)) {
      return _multiSlots[name].build(context);
    }

    return null;
  }
}
