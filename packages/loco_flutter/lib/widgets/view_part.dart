import 'package:flutter/widgets.dart';
import 'package:loco_flutter/loco_flutter.dart';
import 'package:loco_flutter/mixins/state_builder_mixin.dart';

import 'view_base.dart';

/// A ViewPart must be contained within a View
/// A ViewPart itself need not to be registered as Views do
/// A ViewPart cannot but slotted.
/// A ViewPart takes it's channel from the View in which it is contained.
abstract class ViewPart extends StatelessWidget
    with StateBuilderMixin, ViewBase {
  ViewPart({Key key}) : super(key: key);
}
