import 'order.dart';

class Invoice {
  final String id;
  final Order order;
  final String taxAuthorityReference;
  final DateTime submittedAt;
  final InvoiceStatus status;
  final String? errorMessage;
  final int retryCount;
  final DateTime? lastRetryAt;

  Invoice({
    required this.id,
    required this.order,
    required this.taxAuthorityReference,
    required this.submittedAt,
    required this.status,
    this.errorMessage,
    this.retryCount = 0,
    this.lastRetryAt,
  });

  // Convert from JSON
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      order: Order.fromJson(json['order']),
      taxAuthorityReference: json['tax_authority_reference'],
      submittedAt: DateTime.parse(json['submitted_at']),
      status: InvoiceStatus.values.firstWhere(
            (e) => e.toString() == 'InvoiceStatus.${json['status']}',
        orElse: () => InvoiceStatus.pending,
      ),
      errorMessage: json['error_message'],
      retryCount: json['retry_count'] ?? 0,
      lastRetryAt: json['last_retry_at'] != null
          ? DateTime.parse(json['last_retry_at'])
          : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order': order.toJson(),
      'tax_authority_reference': taxAuthorityReference,
      'submitted_at': submittedAt.toIso8601String(),
      'status': status.name,
      'error_message': errorMessage,
      'retry_count': retryCount,
      'last_retry_at': lastRetryAt?.toIso8601String(),
    };
  }

  // Tax Authority JSON format (for submission)
  Map<String, dynamic> toTaxAuthorityJson() {
    return {
      'invoice_id': id,
      'business_tin': 'MPEPO123456', // Mock TIN
      'invoice_date': order.createdAt.toIso8601String(),
      'customer_tin': 'CUST000001', // Mock customer TIN
      'items': order.items.map((item) => {
        'item_name': item.product.name,
        'quantity': item.quantity,
        'unit_price': item.product.price,
        'total_price': item.totalPrice,
        'tax_rate': 0.10, // 10% VAT
      }).toList(),
      'subtotal': order.subtotal,
      'tax_amount': order.taxAmount,
      'discount_amount': order.discountAmount,
      'total_amount': order.total,
      'payment_method': order.paymentMethod,
    };
  }

  // Copy with method
  Invoice copyWith({
    String? id,
    Order? order,
    String? taxAuthorityReference,
    DateTime? submittedAt,
    InvoiceStatus? status,
    String? errorMessage,
    int? retryCount,
    DateTime? lastRetryAt,
  }) {
    return Invoice(
      id: id ?? this.id,
      order: order ?? this.order,
      taxAuthorityReference: taxAuthorityReference ?? this.taxAuthorityReference,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      retryCount: retryCount ?? this.retryCount,
      lastRetryAt: lastRetryAt ?? this.lastRetryAt,
    );
  }
}

enum InvoiceStatus {
  pending('Pending'),
  submitted('Submitted'),
  approved('Approved'),
  rejected('Rejected'),
  failed('Failed');

  const InvoiceStatus(this.displayName);
  final String displayName;
}