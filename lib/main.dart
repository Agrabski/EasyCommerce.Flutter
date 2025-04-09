import 'package:easy_commerce/dashboard/dashboard_page.dart';
import 'package:easy_commerce/data/state.dart';
import 'package:easy_commerce/inventory/inventory_item_page.dart';
import 'package:easy_commerce/inventory/inventory_page.dart';
import 'package:easy_commerce/sale/sale_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';

import 'data/store.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(store: await loadStore()));
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorDashboardKey =
    GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final _shellNavigatorSaleKey = GlobalKey<NavigatorState>(debugLabel: 'sale');
final _shellNavigatorInventoryKey =
    GlobalKey<NavigatorState>(debugLabel: 'inventory');

// Stateful nested navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(
              label: 'Dashboard', icon: Icon(Icons.dashboard)),
          NavigationDestination(
            label: 'Inventory',
            icon: Icon(Icons.inventory),
          ),
          NavigationDestination(label: 'Sale', icon: Icon(Icons.store)),
          NavigationDestination(label: 'Profile', icon: Icon(Icons.person)),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.store});
  final Store<EasyCommerceState> store;
  final _router = GoRouter(routes: [
    StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            ScaffoldWithNestedNavigation(navigationShell: shell),
        branches: [
          StatefulShellBranch(
              navigatorKey: _shellNavigatorDashboardKey,
              routes: [
                GoRoute(
                    path: '/dashboard',
                    builder: (context, _) => DashboardPage())
              ]),
          StatefulShellBranch(
              navigatorKey: _shellNavigatorInventoryKey,
              routes: [
                GoRoute(
                    path: '/inventory',
                    builder: (context, _) => InventoryPage(),
                    routes: [
                      GoRoute(
                          path: 'item/:code',
                          builder: (context, state) => InventoryItemPage(
                              itemCode: state.pathParameters['code']!))
                    ])
              ]),
          StatefulShellBranch(navigatorKey: _shellNavigatorSaleKey, routes: [
            GoRoute(
              path: '/sale',
              redirect: (context, state) => '/sale/${SaleSubPage.Orders}',
            ),
            GoRoute(
                path: '/sale/:subpage',
                builder: (context, state) {
                  return SalePage(
                    subPage: SaleSubPage.values.firstWhere((element) =>
                        element.toString() == state.pathParameters['subpage']),
                  );
                })
          ])
        ])
  ], initialLocation: '/dashboard');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp.router(
          title: 'Flutter',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          routerConfig: _router,
        ));
  }
}
