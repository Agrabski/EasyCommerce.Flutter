import 'package:easy_commerce/data/images.dart';
import 'package:easy_commerce/data/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';

import '../data/reducers/action.dart';

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
          StoreConnector<EasyCommerceState, void Function(InventoryItem)>(
              builder: (context, callback) {
                return IconButton(
                  onPressed: ()=>_onSave(callback),
                  icon: Icon(Icons.save),
                  tooltip: "Save",
                );
              },
              converter: (store) =>
                  (item) => store.dispatch(UpdateInventoryItem(item))),
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
        children: [
          SizedBox(
            height: 200,
            child: CarouselView(
              itemSnapping: true,
              itemExtent: 150,
              children: editedItem.imageNames.map((name) {
                return Padding(
                    padding: EdgeInsets.all(4),
                    child: StoredImageProvider(imageId: name));
              }).toList(),
            ),
          ),
          Row(children: [
            TextButton.icon(
              onPressed: () => addPhoto(ImageSource.camera),
              label: Text("Take a photo"),
              icon: Icon(Icons.add_a_photo),
            ),
            TextButton.icon(
              onPressed: () => addPhoto(ImageSource.gallery),
              label: Text("Pick from gallery"),
              icon: Icon(Icons.image),
            )
          ])
        ],
      )),
    );
  }

  void _onSave(void Function(InventoryItem item) callback) {
    callback(editedItem);
  }

  Future<void> addPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source);
    if (file is XFile) {
      await store(file.name, await file.readAsBytes());
      setState(() {
        editedItem = editedItem.copyWith
            .imageNames(editedItem.imageNames.followedBy([file.name]).toList());
      });
    }
  }
}
