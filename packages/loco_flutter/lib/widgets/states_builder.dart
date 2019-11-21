import 'package:flutter/widgets.dart';
import 'package:loco_flutter/loco_flutter.dart';

import 'common/listen_callback.dart';
import 'state_builder.dart';

class StatesBuilder<T, V extends View> extends StatelessWidget {
  final ListenCallback onListen;
  final Map<Type, dynamic> Function(BuildContext context) builder;
  final Function(BuildContext context) orElse;
  const StatesBuilder(
    this.builder, {
    this.onListen,
    this.orElse,
    Key key,
  })  : assert(builder != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return StateBuilder<T, V>(
      builder: (BuildContext context, AsyncSnapshot<T> state) {
        if (state.connectionState == ConnectionState.active) {
          final builders = builder(context);

          final type = builders.keys.firstWhere((Type stateType) {
            print('${stateType.toString()} == ${state.data.runtimeType}');
            return stateType.toString() == state.data.runtimeType.toString();
          }, orElse: () => null);

          if (type != null) {
            final _builder = builders[type];

            if (_builder != null && state.hasData) {
              return _builder(state.data);
            }
          }
        }

        if (orElse != null) {
          return orElse(context);
        }

        if (state.data == null) {
          // seems to be impossible to not build.
          return Container();
        }

        // seems to be no way to not render?
        throw Exception('Unhandled state ${state.runtimeType}');
      },
    );
  }
}
