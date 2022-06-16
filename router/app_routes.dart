import 'package:flutter/material.dart';

import '../models/models.dart';
import '../screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'home';

  static final menuOptions = <MenuOption>[
    MenuOption(
        route: 'home',
        icon: Icons.list,
        name: 'Home Screen',
        screen: const HomeScreen()),
    MenuOption(
        route: 'details',
        icon: Icons.list_alt_rounded,
        name: 'Detail Screen',
        screen: const DetailsScreen()),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> routes = {};
    routes.addAll({initialRoute: (BuildContext context) => const HomeScreen()});
    for (final item in menuOptions) {
      routes.addAll({item.route: (context) => item.screen});
    }
    return routes;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) =>
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
}
