import 'package:flutter/widgets.dart';
import 'package:loco_flutter/loco_flutter.dart';

import 'extra_actions_part.dart';
import 'filter_button_part.dart';

class HomeViewActionsProps extends ViewProps {
  final bool filterButtonVisible;
  HomeViewActionsProps({
    this.filterButtonVisible = false,
  });
}

class HomeViewActions extends ViewList {
  final HomeViewActionsProps props;
  HomeViewActions(this.props);

  @override
  List<Widget> build(BuildContext context) {
    return [
      FilterButtonPart(visible: props?.filterButtonVisible),
      ExtraActionsPart(),
    ].toList();
  }
}
