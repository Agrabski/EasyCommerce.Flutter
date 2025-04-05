import 'package:easy_commerce/data/state.dart';

abstract interface class ReducerAction {
  EasyCommerceState apply(EasyCommerceState state);
}

abstract class InventoryAction implements ReducerAction {
  @override
  EasyCommerceState apply(EasyCommerceState state) {
    final newInventory = applyInventory(state.inventory);
    return state.copyWith.inventory(newInventory);
  }

  Inventory applyInventory(Inventory inventory);
}

final class CreateInventoryItem extends InventoryAction {
  final InventoryItem item;

  CreateInventoryItem(this.item);

  @override
  Inventory applyInventory(Inventory inventory) {
    var newInventory = <String, InventoryItem>{};
    for (var element in inventory.content.keys) {
      newInventory[element] = inventory.content[element]!;
    }
    newInventory[item.code] = item;
    return inventory.copyWith.content(newInventory);
  }
}

final class UpdateInventoryItem extends InventoryAction{
  final InventoryItem item;

  UpdateInventoryItem(this.item);

  @override
  Inventory applyInventory(Inventory inventory) {
    var newInventory = <String, InventoryItem>{};
    for (var element in inventory.content.keys) {
      newInventory[element] = inventory.content[element]!;
    }
    newInventory[item.code] = item;
    return inventory.copyWith.content(newInventory);
  }
}