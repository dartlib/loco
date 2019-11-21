import 'package:flutter/widgets.dart';
import 'package:loco_example/localization.dart';
import 'package:loco_flutter/loco_flutter.dart';

class HomeViewTitle extends View {
  @override
  Widget build(BuildContext context) {
    return Text(
      LocoExampleLocalizations.of(context).appTitle,
    );
  }
}
