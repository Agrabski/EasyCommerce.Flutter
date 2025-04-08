import 'dart:collection';

import 'package:easy_commerce/data/reducers/action.dart';
import 'package:easy_commerce/data/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fuzzy/data/fuzzy_options.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';

import '../data/images.dart';

class InventoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InventoryPageState();
  }
}

class _InventoryPageState extends State<InventoryPage> {
  final HashSet<String> _selectedItems = HashSet();
  final options = FuzzyOptions(keys: [
    WeightedKey<InventoryItem>(name: 'Name', getter: (i) => i.name, weight: 1),
    WeightedKey<InventoryItem>(
        name: 'Description', getter: (i) => i.description, weight: 0.3),
    WeightedKey<InventoryItem>(
        name: 'Tags', getter: (i) => i.tags.join(","), weight: 0.5)
  ]);
  String? _query;

  @override
  Widget build(BuildContext _) {
    return StoreConnector<EasyCommerceState, Store<EasyCommerceState>>(
        converter: (s) => s,
        builder: (context, store) => Scaffold(
              appBar: AppBar(
                title: _query == null ? Text('Inventory') : _buildSearchBar(),
                leading: _query == null
                    ? null
                    : BackButton(
                        onPressed: () => setState(() => _query = null)),
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                actions: _buildActions(context, store),
              ),
              body: StoreConnector<EasyCommerceState, _ViewModel>(
                converter: (store) => _ViewModel(Fuzzy(
                    store.state.inventory.content.values.toList(),
                    options: options)),
                builder: (builder, model) => GridView.count(
                  crossAxisCount: 3,
                  children: (_query == null
                          ? model.fuzzy.list.map((i) => i.code)
                          : model.fuzzy.search(_query!).map((r) => r.item.code))
                      .map((item) => _InventoryItemHeader(
                            itemId: item,
                            onSelected: (code) => setState(() {
                              _selectedItems.add(code);
                            }),
                            selected: _selectedItems.contains(item),
                            onDeselected: (code) => setState(() {
                              _selectedItems.remove(code);
                            }),
                            anySelected: _selectedItems.isNotEmpty,
                          ))
                      .toList(),
                ),
              ),
              floatingActionButton:
                  StoreConnector<EasyCommerceState, VoidCallback>(
                converter: (store) => (() {
                  final id = store.state.inventory.nextId();
                  store.dispatch(CreateInventoryItem(
                      InventoryItem(id, '', [], '', 0, 0, [])));
                  context.go('/inventory/item/$id');
                }),
                builder: (context, callback) => FloatingActionButton(
                  onPressed: callback,
                  child: Icon(Icons.add),
                ),
              ),
            ));
  }

  Future _deleteSelectedItems(Store<EasyCommerceState> store) async {
    final result = await showDialog<bool>(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Text("Delete items"),
            content: Text(
                "Are you sure you want to delete ${_selectedItems.length} items?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(c, false),
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () => Navigator.pop(c, true),
                  child: Text("Delete"))
            ],
          );
        });
    if (result == true) {
      final count = _selectedItems.length;
      store.dispatch(DeleteInventoryItems(_selectedItems));
      setState(() {
        _selectedItems.clear();
      });
      final snackBar = SnackBar(
          content: Row(
              children: [Icon(Icons.delete), Text('Deleted $count items')]));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  List<Widget>? _buildActions(
      BuildContext context, Store<EasyCommerceState> store) {
    if (_selectedItems.isEmpty) {
      if(_query==null) {
        return [
          IconButton(
              onPressed: () => setState(() => _query = ""),
              icon: Icon(Icons.search),
              tooltip: "Search")
        ];
      }
      return null;
    }
    return [
      PopupMenuButton(
        itemBuilder: (c) {
          return [
            PopupMenuItem(
                child: Row(
                  children: [Icon(Icons.delete), Text("Delete")],
                ),
                onTap: () => _deleteSelectedItems(store))
          ];
        },
        icon: Icon(Icons.more_vert),
      )
    ];
  }

  Widget _buildSearchBar() {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      style: TextStyle(fontSize: 16.0),
      onChanged: (query) => setState(() => _query = query),
    );
  }
}

class _ViewModel {
  final Fuzzy<InventoryItem> fuzzy;

  _ViewModel(this.fuzzy);
}

class _InventoryItemHeader extends StatelessWidget {
  final String itemId;
  final bool selected;
  final bool anySelected;
  final void Function(String code) onSelected;
  final void Function(String code) onDeselected;

  const _InventoryItemHeader(
      {required this.itemId,
      required this.onSelected,
      required this.selected,
      required this.onDeselected,
      required this.anySelected});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<EasyCommerceState, _InventoryItemHeaderModel>(
        converter: (store) {
      final item = store.state.inventory.content[itemId];
      if (item == null) {
        throw Error();
      }
      return _InventoryItemHeaderModel(
          name: item.name,
          imageId: item.imageNames.firstOrNull,
          code: item.code);
    }, builder: (context, model) {
      return GestureDetector(
        child: Container(
            decoration: selected
                ? BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1))
                : null,
            child: Padding(
                padding: EdgeInsets.all(6),
                child: Column(
                  children: [
                    SizedBox(
                        height: 100,
                        child: Badge(
                            isLabelVisible: selected,
                            label: Icon(Icons.check),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child:
                                StoredImageProvider(imageId: model.imageId))),
                    Text(model.name)
                  ],
                ))),
        onTap: () {
          if (!selected) {
            if (anySelected) {
              onSelected(model.code);
            } else {
              context.go('/inventory/item/${model.code}');
            }
          } else {
            onDeselected(model.code);
          }
        },
        onLongPress: () => onSelected(model.code),
      );
    });
  }
}

class _InventoryItemHeaderModel {
  final String name;
  final String? imageId;
  final String code;

  _InventoryItemHeaderModel(
      {required this.name, required this.code, required this.imageId});
}
