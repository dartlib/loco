import 'package:flutter/widgets.dart';
import 'package:loco_flutter/slots.dart';
import 'package:loco_flutter/widgets/view_base.dart';

import '../mixins/channel_mixin.dart';
import '../mixins/state_builder_mixin.dart';

/// A view list can do anything a View does yet
/// returns a list of widgets.
///
/// These are used to populate slot but also can be used within normal widgets.
/// Slots' will automatically call the build() method.
///
/// When used as normal widgets the build method must be called separately.
///
/// MyViewList(MyViewProps(..)).build(context);
///
abstract class ViewList with ChannelMixin, StateBuilderMixin, Slots, ViewBase {
  List<Widget> build(BuildContext context);
}
