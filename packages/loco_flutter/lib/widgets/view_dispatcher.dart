import 'package:flutter/material.dart';
import 'package:loco_flutter/widgets/view.dart';

class ViewDispatcher {
  static of<V extends View>(BuildContext context) {
    final channel = View.of<V>(context).channel;

    return (event) {
      return channel.dispatch(event);
    };
  }
}
