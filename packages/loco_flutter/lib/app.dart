import 'package:loco/loco.dart';

import 'mixins/navigation_mixin.dart';

/// App
///
/// App is an extension
///
/// Seems to be more like a Navigation Mixin
///
/// So added functionality which can be mixed in on an extension.
///
abstract class App<BaseState> extends Extension<BaseState>
    with NavigationMixin {}
