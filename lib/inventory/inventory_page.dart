import 'package:easy_commerce/data/reducers/action.dart';
import 'package:easy_commerce/data/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class InventoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InventoryPageState();
  }
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StoreConnector<EasyCommerceState, _ViewModel>(
        converter: (store) => _ViewModel(store.state.inventory.content),
        builder: (builder, model) => GridView.count(
          crossAxisCount: 3,
          children: model.items
              .map((item) => Column(
                    children: [Container(), Text(item.name)],
                  ))
              .toList(),
        ),
      ),
      floatingActionButton: StoreConnector<EasyCommerceState, VoidCallback>(
        converter: (store) => (() => store.dispatch(CreateInventoryItem(
            InventoryItem(store.state.inventory.nextId(), 'test')))),
        builder: (context, callback) =>
            FloatingActionButton(onPressed: callback),
      ),
    );
  }
}

class _ViewModel {
  final List<InventoryItem> items;

  _ViewModel(this.items);
}
