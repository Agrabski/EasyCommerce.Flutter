import 'package:easy_commerce/data/images.dart';
import 'package:easy_commerce/data/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';

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
  final _key = GlobalKey<FormState>();
  final _stringTagController = StringTagController();
  @override
  void initState() {
    super.initState();
    editedItem = widget.editedItem;
  }

  @override
  Widget build(BuildContext context) {
    final distanceToField = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory item"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          StoreConnector<EasyCommerceState, void Function(InventoryItem)>(
              builder: (context, callback) {
                return IconButton(
                  onPressed: () => _onSave(callback),
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
          key: _key,
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
              ]),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                ),
                onSaved: (value) {
                  setState(() {
                    editedItem = editedItem.copyWith.name(value!);
                  });
                },
                initialValue: editedItem.name,
                validator: (v) => v == null ? "Name is required" : null,
              ),
              TextFormField(
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 12 * 4),
                decoration: InputDecoration(
                  labelText: "Description",
                ),
                onSaved: (value) {
                  setState(() {
                    editedItem = editedItem.copyWith.description(value!);
                  });
                },
                initialValue: editedItem.description,
                validator: (v) => v == null ? "Description is required" : null,
              ),
              TextFormField(
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 12 * 4),
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                decoration: InputDecoration(
                  labelText: "Price",
                ),
                onSaved: (value) {
                  setState(() {
                    editedItem = editedItem.copyWith
                        .priceInPennies((double.parse(value!) * 100).toInt());
                  });
                },
                initialValue: (editedItem.priceInPennies / 100).toString(),
                validator: (v) => v == null ? "Price is required" : null,
              ),
              TextFormField(
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 12 * 4),
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                decoration: InputDecoration(
                  labelText: "Quantity",
                ),
                onSaved: (value) {
                  setState(() {
                    editedItem =
                        editedItem.copyWith.quantity((int.parse(value!)));
                  });
                },
                initialValue: editedItem.quantity.toString(),
                validator: (v) => v == null ? "Quantity is required" : null,
              ),
              Autocomplete<String>(
                optionsViewBuilder: (context, onSelected, options) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 4.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Material(
                        elevation: 4.0,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return TextButton(
                                onPressed: () {
                                  onSelected(option);
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '#$option',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 74, 137, 92),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return editedItem.tags.where((String option) {
                    return option.contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selectedTag) {
                  _stringTagController.onTagSubmitted(selectedTag);
                },
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  return TextFieldTags<String>(
                    textEditingController: textEditingController,
                    focusNode: focusNode,
                    textfieldTagsController: _stringTagController,
                    initialTags: editedItem.tags,
                    textSeparators: const [' ', ','],
                    letterCase: LetterCase.normal,
                    inputFieldBuilder: (context, inputFieldValues) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          controller: inputFieldValues.textEditingController,
                          focusNode: inputFieldValues.focusNode,
                          decoration: InputDecoration(
                            isDense: true,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 74, 137, 92),
                                width: 3.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 74, 137, 92),
                                width: 3.0,
                              ),
                            ),
                            helperText: 'Tags',
                            helperStyle: const TextStyle(
                              color: Color.fromARGB(255, 74, 137, 92),
                            ),
                            hintText: inputFieldValues.tags.isNotEmpty
                                ? ''
                                : "Enter tag...",
                            errorText: inputFieldValues.error,
                            prefixIconConstraints:
                            BoxConstraints(maxWidth: distanceToField * 0.74),
                            prefixIcon: inputFieldValues.tags.isNotEmpty
                                ? SingleChildScrollView(
                              controller:
                              inputFieldValues.tagScrollController,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: inputFieldValues.tags
                                      .map((String tag) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color: Color.fromARGB(255, 74, 137, 92),
                                      ),
                                      margin:
                                      const EdgeInsets.only(right: 10.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              '#$tag',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              //print("$tag selected");
                                            },
                                          ),
                                          const SizedBox(width: 4.0),
                                          InkWell(
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 14.0,
                                              color: Color.fromARGB(
                                                  255, 233, 233, 233),
                                            ),
                                            onTap: () {
                                              inputFieldValues
                                                  .onTagRemoved(tag);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList()),
                            )
                                : null,
                          ),
                          onChanged: inputFieldValues.onTagChanged,
                          onSubmitted: inputFieldValues.onTagSubmitted,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          )),
    );
  }

  void _onSave(void Function(InventoryItem item) callback) {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      callback(editedItem.copyWith.tags(_stringTagController.getTags!));
      const snackBar = SnackBar(content: Row(children: [Icon(Icons.check_circle_rounded), Text('Saved')]));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
