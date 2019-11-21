import 'package:flutter/widgets.dart';

typedef _RouteFactory = Route<dynamic> Function(Map<String, dynamic> arguments);

abstract class NavigationMixin {
  final Map<String, _RouteFactory> routes = {};

  addRoute<T>(String name, _RouteFactory factory) {
    if (!routes.containsKey(name)) {
      routes[name] = factory;
    } else {
      throw ArgumentError('Route $name already exists');
    }
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic> ?? {};

    if (routes.containsKey(settings.name)) {
      return routes[settings.name](arguments);
    }

    throw ArgumentError('Route ${settings.name} does not exist');
  }

  PageRouteBuilder buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (BuildContext context, _, __) {
        return page;
      },
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
