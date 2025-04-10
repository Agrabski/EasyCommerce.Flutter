import 'dart:math';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class EasyCommerceState {
  EasyCommerceState(this.inventory);
  factory EasyCommerceState.empty() => EasyCommerceState(Inventory.empty());
  factory EasyCommerceState.fromJson(dynamic json) =>
      _$EasyCommerceStateFromJson(json);
  dynamic toJson() => _$EasyCommerceStateToJson(this);
  final Inventory inventory;
}

@JsonSerializable(explicitToJson: true)
@CopyWith()
class Orders {
  Orders(this.content);
  factory Orders.empty() => Orders([]);

  factory Orders.fromJson(dynamic json) => _$OrdersFromJson(json);

  dynamic toJson() => _$OrdersToJson(this);
  final List<Order> content;
}

@JsonSerializable(explicitToJson: true)
@CopyWith()
class Order {
  Order(this.code, this.items);
  factory Order.fromJson(dynamic json) => _$OrderFromJson(json);

  dynamic toJson() => _$OrderToJson(this);
  final String code;
  final List<OrderItem> items;
}


@JsonSerializable(explicitToJson: true)
@CopyWith()
class OrderItem {
  final String itemCode;
  final int quantity;
  final int percentageDiscount;
  final int absoluteDiscount;
  OrderItem(this.itemCode, this.quantity, this.percentageDiscount, this.absoluteDiscount);
  factory OrderItem.fromJson(dynamic json) => _$OrderItemFromJson(json);
  dynamic toJson() => _$OrderItemToJson(this);

}

@JsonSerializable(explicitToJson: true)
@CopyWith()
class Inventory {
  Inventory(this.content);

  factory Inventory.empty() => Inventory({});

  factory Inventory.fromJson(dynamic json) => _$InventoryFromJson(json);

  dynamic toJson() => _$InventoryToJson(this);

  final Map<String, InventoryItem> content;

  String nextId() {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        4, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}

@JsonSerializable(explicitToJson: true)
@CopyWith()
class InventoryItem {
  InventoryItem(this.code, this.name, this.imageNames, this.description,
      this.quantity, this.priceInPennies, this.tags);

  factory InventoryItem.fromJson(dynamic json) => _$InventoryItemFromJson(json);
  dynamic toJson() => _$InventoryItemToJson(this);

  final String code;

  final String name;
  final String description;
  final int quantity;
  final int priceInPennies;
  final List<String> tags;

  final List<String> imageNames;
}
