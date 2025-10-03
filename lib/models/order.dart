import "product.dart" show Product;

import 'cart_item.dart';

class Order {
  final int id;
  final List<CartItem> items;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double total;
  final String paymentMethod;
  final DateTime createdAt;
  String? eInvoiceRef;
  bool syncedToTaxAuthority;
  OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
    this.eInvoiceRef,
    this.syncedToTaxAuthority = false,
    this.status = OrderStatus.completed,
  });

  // Convert from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List).map((itemJson) =>
          CartItem.fromJson(itemJson, Product.fromJson(itemJson['product']))
      ).toList(),
      subtotal: json['subtotal'].toDouble(),
      taxAmount: json['tax_amount'].toDouble(),
      discountAmount: json['discount_amount'].toDouble(),
      total: json['total'].toDouble(),
      paymentMethod: json['payment_method'],
      createdAt: DateTime.parse(json['created_at']),
      eInvoiceRef: json['e_invoice_ref'],
      syncedToTaxAuthority: json['synced_to_tax_authority'] ?? false,
      status: OrderStatus.values.firstWhere(
            (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.completed,
      ),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax_amount': taxAmount,
      'discount_amount': discountAmount,
      'total': total,
      'payment_method': paymentMethod,
      'created_at': createdAt.toIso8601String(),
      'e_invoice_ref': eInvoiceRef,
      'synced_to_tax_authority': syncedToTaxAuthority,
      'status': status.name,
    };
  }

  // Copy with method
  Order copyWith({
    int? id,
    List<CartItem>? items,
    double? subtotal,
    double? taxAmount,
    double? discountAmount,
    double? total,
    String? paymentMethod,
    DateTime? createdAt,
    String? eInvoiceRef,
    bool? syncedToTaxAuthority,
    OrderStatus? status,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      eInvoiceRef: eInvoiceRef ?? this.eInvoiceRef,
      syncedToTaxAuthority: syncedToTaxAuthority ?? this.syncedToTaxAuthority,
      status: status ?? this.status,
    );
  }
}

enum OrderStatus {
  pending('Pending'),
  completed('Completed'),
  cancelled('Cancelled'),
  refunded('Refunded');

  const OrderStatus(this.displayName);
  final String displayName;
}