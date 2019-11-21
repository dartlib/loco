import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loco_example/keys.dart';
import 'package:loco_example/widgets/loading_indicator.dart';
import 'package:loco_flutter/loco_flutter.dart';
import 'package:todos_app_core/todos_app_core.dart';

import './stats_state.dart';

class StatsView extends View {
  final name = 'stats-view';

  @override
  Widget build(BuildContext context) {
    final locale = ArchSampleLocalizations.of(context);

    return buildStates<StatsState, StatsView>(
      (BuildContext context) => {
        StatsLoadingState: (StatsLoadingState state) => LoadingIndicator(
              key: LocoExampleKeys.statsLoading,
            ),
        StatsLoadedState: (StatsLoadedState state) {
          final textTheme = Theme.of(context).textTheme;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    locale.completedTodos,
                    style: textTheme.title,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    '${state.numCompleted}',
                    key: LocoExampleKeys.statsNumCompleted,
                    style: textTheme.subhead,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    locale.activeTodos,
                    style: textTheme.title,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    "${state.numActive}",
                    key: LocoExampleKeys.statsNumActive,
                    style: textTheme.subhead,
                  ),
                )
              ],
            ),
          );
        },
      },
      orElse: (BuildContext context) {
        // return Container(key: BlocLibraryKeys.emptyStatsContainer);
        return Container();
      },
    );
  }
}
