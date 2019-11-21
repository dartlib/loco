import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'app_tab.dart';

@immutable
abstract class TabEvent extends Equatable {
  TabEvent([List props = const []]);

  get props => [];
}

class UpdateTabEvent extends TabEvent {
  final AppTab tab;

  UpdateTabEvent(this.tab);

  get props => [tab];

  @override
  String toString() => 'UpdateTab { tab: $tab }';
}
