import 'package:easy_commerce/sale/sale_mode_display.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'orders_display.dart';

enum SaleSubPage { SaleMode, Orders }

class SalePage extends StatelessWidget {
  final SaleSubPage subPage;

  const SalePage({super.key, required this.subPage});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Sale'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('Sale mode'),
                onTap: () {
                  Navigator.of(context).pop();
                  GoRouter.of(context).go('/sale/${SaleSubPage.SaleMode}');
                },
                selected: subPage == SaleSubPage.SaleMode,
              ),
              ListTile(
                leading: Icon(Icons.list_alt),
                title: Text('Orders'),
                onTap: () {
                  Navigator.of(context).pop();
                  GoRouter.of(context).go('/sale/${SaleSubPage.Orders}');
                },
                selected: subPage == SaleSubPage.Orders,
              ),
            ],
          ),
        ),
        body: switch (subPage) {
          SaleSubPage.SaleMode => SaleModeDisplay(),
          SaleSubPage.Orders => OrdersDisplay(),
        });
  }
}
