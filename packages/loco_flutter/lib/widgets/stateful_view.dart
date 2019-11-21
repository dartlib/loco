import 'package:flutter/widgets.dart';
import 'package:loco_flutter/mixins/channel_mixin.dart';

import 'common/view_props.dart';
import 'view_base.dart';
import 'view_state.dart';

abstract class StatefulView<TProps extends ViewProps> extends StatefulWidget
    with ChannelMixin, ViewBase {
  final TProps props;
  StatefulView(this.props) : super(key: props?.key);

  @protected
  ViewState createState();
}
