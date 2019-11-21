import 'package:flutter/widgets.dart';
import 'package:loco/loco.dart';

import 'view_base.dart';

class ViewBuilderEvent<T extends ViewBase> {}

/// ViewBuilder is a [StatefulWidget] wrapping views which are being slotted
/// into the layout.
///
/// The ViewBuilder will rebuild itself when a [ViewBuilderEvent] is received.
///
/// The event will be in the form `ViewBuilderEvent<MyView>()`
///
/// The generic type ensures the event is only received by Views of that type.
///
/// MyView in this case will contain the slot in the build method which need
/// to be rebuild.
///
/// Currently the event is mainly used to rebuild the views when any of
/// it's slots have been changed, in which case the View will rebuild and
/// the slot updates will take effect.
class ViewBuilder<T extends ViewBuilderEvent> extends StatefulWidget {
  final Widget Function() viewFactory;
  final Channel channel;
  ViewBuilder({
    Key key,
    this.channel,
    this.viewFactory,
  }) : super(key: key);

  @override
  _ViewBuilderState createState() => _ViewBuilderState<T>();
}

class _ViewBuilderState<T extends ViewBuilderEvent> extends State<ViewBuilder> {
  CancelSubscription _cancelSubscription;
  @override
  void initState() {
    _cancelSubscription = widget.channel.onEvent<T>(this, _handleEvent);
    super.initState();
  }

  @override
  void dispose() {
    _cancelSubscription();
    super.dispose();
  }

  void _handleEvent(ViewBuilderEvent event) => setState(() => {});

  @override
  Widget build(BuildContext context) {
    return widget.viewFactory();
  }
}
