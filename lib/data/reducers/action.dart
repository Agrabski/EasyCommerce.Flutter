import 'package:easy_commerce/data/state.dart';

abstract interface class ReducerAction {
  EasyCommerceState apply(EasyCommerceState state);
}

abstract class InventoryAction implements ReducerAction {
  @override
  EasyCommerceState apply(EasyCommerceState state) {
    final newInventory = apply_inventory(state.inventory);
    return state.copyWith.inventory(newInventory);
  }

  Inventory apply_inventory(Inventory inventory);
}

final class CreateInventoryItem extends InventoryAction {
  final InventoryItem item;

  CreateInventoryItem(this.item);

  @override
  Inventory apply_inventory(Inventory inventory) {
    return inventory.copyWith.content([...inventory.content, item]);
  }
}
