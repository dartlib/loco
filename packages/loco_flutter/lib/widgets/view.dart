import 'package:flutter/widgets.dart';
import 'package:loco_flutter/mixins/channel_mixin.dart';
import 'package:loco_flutter/mixins/state_builder_mixin.dart';
import 'package:loco_flutter/widgets/view_base.dart';

import '../slots.dart';
import 'common/view_props.dart';

abstract class View<TProps extends ViewProps> extends StatelessWidget
    with ChannelMixin, StateBuilderMixin, Slots, ViewBase {
  final TProps props;
  View([TProps props])
      : this.props = props ?? ViewProps(),
        super(key: props?.key);

  static $() {
    throw ArgumentError('Must implement static method \$');
  }

  // not used yet.
  void onAttach(context, channel, slot) {}

  static T of<T extends View>(BuildContext context) {
    // Ok doesn't find an extended view
    final View viewAncestor = context.ancestorWidgetOfExactType(T);
    if (viewAncestor == null) {
      throw ArgumentError('No ancestor widget of type $T found');
    }

    if (viewAncestor.channel == null) {
      throw ArgumentError('View $T was not properly registered');
    }

    return viewAncestor;
  }
}
