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
        converter: (store) =>
            _ViewModel(store.state.inventory.content.keys.toList()),
        builder: (builder, model) => GridView.count(
          crossAxisCount: 3,
          children: model.itemIds
              .map((item) => _InventoryItemHeader(itemId: item))
              .toList(),
        ),
      ),
      floatingActionButton: StoreConnector<EasyCommerceState, VoidCallback>(
        converter: (store) => (() => store.dispatch(CreateInventoryItem(
            InventoryItem(store.state.inventory.nextId(), 'test', [])))),
        builder: (context, callback) =>
            FloatingActionButton(onPressed: callback),
      ),
    );
  }
}

class _ViewModel {
  final List<String> itemIds;

  _ViewModel(this.itemIds);
}

class _InventoryItemHeader extends StatelessWidget {
  final String itemId;

  const _InventoryItemHeader({required this.itemId});
  @override
  Widget build(BuildContext context) {
    return StoreConnector<EasyCommerceState, _InventoryItemHeaderModel>(
        converter: (store) {
          final item = store.state.inventory.content[itemId];
          if (item == null) {
            throw Error();
          }
          return _InventoryItemHeaderModel(
              name: item.name, imageName: item.imageNames.firstOrNull);
        },
        builder: (context, model) => Column(
              children: [Container(), Text(model.name)],
            ));
  }
}

class _InventoryItemHeaderModel {
  final String name;
  final String? imageName;

  _InventoryItemHeaderModel({required this.name, required this.imageName});
}
