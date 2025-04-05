import 'package:easy_commerce/data/images.dart';
import 'package:easy_commerce/data/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class InventoryItemPage extends StatelessWidget {
  final String itemCode;

  const InventoryItemPage({super.key, required this.itemCode});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<EasyCommerceState, InventoryItem>(
        builder: (context, model) {
      return _InventoryItemEditPage(
        editedItem: model,
        onSave: (newValue) {},
      );
    }, converter: (store) {
      return store.state.inventory.content[itemCode]!;
    });
  }
}

class _InventoryItemEditPage extends StatefulWidget {
  final InventoryItem editedItem;
  final Function(InventoryItem newValue) onSave;

  const _InventoryItemEditPage(
      {super.key, required this.editedItem, required this.onSave});

  @override
  State<StatefulWidget> createState() {
    return _InventoryItemEditPageState();
  }
}

class _InventoryItemEditPageState extends State<_InventoryItemEditPage> {
  late InventoryItem editedItem;
  @override
  void initState() {
    super.initState();
    editedItem = widget.editedItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory item"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _onSave,
            icon: Icon(Icons.save),
            tooltip: "Save",
          ),
          PopupMenuButton(
            itemBuilder: (c) {
              return [];
            },
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      body: Form(
          child: Column(
        children: [],
      )),
    );
  }

  void _onSave() {}
}
