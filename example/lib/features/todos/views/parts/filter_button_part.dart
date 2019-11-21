import 'package:flutter/material.dart';
import 'package:loco_example/features/todos/events/filtered_todos_event.dart';
import 'package:loco_example/features/todos/models/visibility_filter.dart';
import 'package:loco_example/features/todos/state/filtered_todos_state.dart';
import 'package:loco_example/keys.dart';
import 'package:loco_flutter/loco_flutter.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../home_view.dart';

class FilterButtonPart extends ViewPart {
  final name = 'filter-button';

  final bool visible;

  FilterButtonPart({this.visible, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.body1;
    final activeStyle = Theme.of(context)
        .textTheme
        .body1
        .copyWith(color: Theme.of(context).accentColor);
    return buildState<FilteredTodosState, HomeView>(
      builder: (BuildContext context, AsyncSnapshot<FilteredTodosState> state) {
        final dispatch = ViewDispatcher.of<HomeView>(context);

        final button = _Button(
          onSelected: (filter) {
            dispatch(UpdateFilterEvent(filter));
          },
          activeFilter: state.data is FilteredTodosLoadedState
              ? (state.data as FilteredTodosLoadedState).activeFilter
              : VisibilityFilter.all,
          activeStyle: activeStyle,
          defaultStyle: defaultStyle,
        );
        return AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 150),
          child: visible ? button : IgnorePointer(child: button),
        );
      },
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key key,
    @required this.onSelected,
    @required this.activeFilter,
    @required this.activeStyle,
    @required this.defaultStyle,
  }) : super(key: key);

  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final TextStyle activeStyle;
  final TextStyle defaultStyle;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<VisibilityFilter>(
      key: LocoExampleKeys.filterButton,
      tooltip: ArchSampleLocalizations.of(context).filterTodos,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuItem<VisibilityFilter>>[
        PopupMenuItem<VisibilityFilter>(
          key: LocoExampleKeys.allFilter,
          value: VisibilityFilter.all,
          child: Text(
            ArchSampleLocalizations.of(context).showAll,
            style: activeFilter == VisibilityFilter.all
                ? activeStyle
                : defaultStyle,
          ),
        ),
        PopupMenuItem<VisibilityFilter>(
          key: LocoExampleKeys.activeFilter,
          value: VisibilityFilter.active,
          child: Text(
            ArchSampleLocalizations.of(context).showActive,
            style: activeFilter == VisibilityFilter.active
                ? activeStyle
                : defaultStyle,
          ),
        ),
        PopupMenuItem<VisibilityFilter>(
          key: LocoExampleKeys.completedFilter,
          value: VisibilityFilter.completed,
          child: Text(
            ArchSampleLocalizations.of(context).showCompleted,
            style: activeFilter == VisibilityFilter.completed
                ? activeStyle
                : defaultStyle,
          ),
        ),
      ],
      icon: Icon(Icons.filter_list),
    );
  }
}
