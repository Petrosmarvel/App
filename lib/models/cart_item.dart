import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  String? notes;
  List<String> modifications;

  CartItem({
    required this.product,
    required this.quantity,
    this.notes,
    this.modifications = const [],
  });

  double get totalPrice => product.price * quantity;

  // Convert from JSON
  factory CartItem.fromJson(Map<String, dynamic> json, Product product) {
    return CartItem(
      product: product,
      quantity: json['quantity'],
      notes: json['notes'],
      modifications: List<String>.from(json['modifications'] ?? []),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_id': product.id,
      'quantity': quantity,
      'notes': notes,
      'modifications': modifications,
      'unit_price': product.price,
      'total_price': totalPrice,
    };
  }

  // Copy with method
  CartItem copyWith({
    Product? product,
    int? quantity,
    String? notes,
    List<String>? modifications,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      modifications: modifications ?? this.modifications,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CartItem &&
              runtimeType == other.runtimeType &&
              product.id == other.product.id;

  @override
  int get hashCode => product.id.hashCode;
}