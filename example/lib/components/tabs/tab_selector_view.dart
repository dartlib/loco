import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loco_example/keys.dart';
import 'package:loco_flutter/loco_flutter.dart';
import 'package:todos_app_core/todos_app_core.dart';

import 'app_tab.dart';
import 'tab_event.dart';

class TabSelectorProps extends ViewProps {
  final AppTab activeTab;
  TabSelectorProps({
    Key key,
    @required this.activeTab,
  }) : super(key: key);
}

class TabSelectorView extends View<TabSelectorProps> {
  TabSelectorView(props) : super(props);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      key: LocoExampleKeys.tabs,
      currentIndex: AppTab.values.indexOf(props.activeTab),
      onTap: (index) => dispatch(
        UpdateTabEvent(
          AppTab.values[index],
        ),
      ),
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            tab == AppTab.todos ? Icons.list : Icons.show_chart,
            key: tab == AppTab.todos
                ? LocoExampleKeys.todoTab
                : LocoExampleKeys.statsTab,
          ),
          title: Text(tab == AppTab.stats
              ? ArchSampleLocalizations.of(context).stats
              : ArchSampleLocalizations.of(context).todos),
        );
      }).toList(),
    );
  }
}
