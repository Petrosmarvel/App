

import 'package:flutter/material.dart';
import 'products_screen.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class ReceiptScreen extends StatelessWidget {
final Order order;

const ReceiptScreen({super.key, required this.order});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Order Complete'),
actions: [
IconButton(
icon: const Icon(Icons.print_outlined),
onPressed: () => _printReceipt(context),
tooltip: 'Print Receipt',
),
IconButton(
icon: const Icon(Icons.share_outlined),
onPressed: () => _shareReceipt(context),
tooltip: 'Share Receipt',
),
],
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
children: [
// Success Message
Card(
color: Colors.green[50],
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Row(
children: [
Icon(Icons.check_circle, color: Colors.green[700], size: 32),
const SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Payment Successful!',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: Colors.green[700],
),
),
Text(
'Order #${order.id} has been completed',
style: TextStyle(
color: Colors.green[600],
),
),
],
),
),
],
),
),
),

const SizedBox(height: 16),

// Receipt Header
Card(
child: Padding(
padding: const EdgeInsets.all(20.0),
child: Column(
children: [
Icon(Icons.restaurant, size: 48, color: Theme.of(context).primaryColor),
const SizedBox(height: 8),
const Text(
'Mpepo Kitchen',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 4),
const Text(
'123 Main Street, City',
style: TextStyle(fontSize: 14),
),
const SizedBox(height: 2),
const Text(
'Tel: 555-1234',
style: TextStyle(fontSize: 14),
),
const SizedBox(height: 8),
Text(
'www.mpepokitchen.com',
style: TextStyle(
fontSize: 12,
color: Colors.grey[600],
),
),
],
),
),
),

const SizedBox(height: 16),

// Order Details
Card(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'ORDER DETAILS',
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 16,
),
),
const SizedBox(height: 12),
_buildReceiptRow('Order Number:', '#${order.id}'),
_buildReceiptRow('Date:', _formatDate(order.createdAt)),
_buildReceiptRow('Time:', _formatTime(order.createdAt)),
_buildReceiptRow('Cashier:', 'John Doe'),
_buildReceiptRow('Payment Method:', order.paymentMethod),
],
),
),
),

const SizedBox(height: 16),

// Order Items
Card(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
children: [
const Text(
'ORDER ITEMS',
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 16,
),
),
const SizedBox(height: 12),
...order.items.map((item) => Padding(
padding: const EdgeInsets.symmetric(vertical: 6.0),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Expanded(
flex: 2,
child: Text(
'${item.quantity}x ${item.product.name}',
style: const TextStyle(fontWeight: FontWeight.w500),
),
),
Expanded(
flex: 1,
child: Text(
'\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
style: const TextStyle(fontWeight: FontWeight.bold),
textAlign: TextAlign.right,
),
),
],
),
)),
],
),
),
),

const SizedBox(height: 16),

// Totals
Card(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
children: [
_buildTotalRow('Subtotal:', order.subtotal),
_buildTotalRow('Tax (10%):', order.taxAmount),
if (order.discountAmount > 0)
_buildTotalRow('Discount:', -order.discountAmount),
const Divider(),
_buildTotalRow(
'TOTAL:',
order.total,
isTotal: true,
),
],
),
),
),

const SizedBox(height: 16),

// E-Invoice Status
Card(
color: Colors.green[50],
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
children: [
const Row(
children: [
Icon(Icons.receipt_long, color: Colors.green),
SizedBox(width: 8),
Text(
'E-Invoice Status',
style: TextStyle(
fontWeight: FontWeight.bold,
color: Colors.green,
),
),
],
),
const SizedBox(height: 8),
Row(
children: [
Icon(Icons.check_circle, color: Colors.green[700], size: 16),
const SizedBox(width: 4),
const Text('Submitted to TRA'),
const Spacer(),
Text(
'REF: INV-TA-2025-${order.id}',
style: TextStyle(
fontSize: 12,
color: Colors.grey[600],
),
),
],
),
],
),
),
),

const SizedBox(height: 24),

// Thank You Message
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.grey[50],
borderRadius: BorderRadius.circular(8),
),
child: const Column(
children: [
Icon(Icons.thumb_up_alt_outlined, size: 32, color: Colors.grey),
SizedBox(height: 8),
Text(
'Thank you for your order!',
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 16,
),
),
SizedBox(height: 4),
Text(
'We hope to see you again soon',
textAlign: TextAlign.center,
style: TextStyle(color: Colors.grey),
),
],
),
),

const SizedBox(height: 24),

// Action Buttons
Row(
children: [
Expanded(
child: OutlinedButton.icon(
onPressed: () => _emailReceipt(context),
icon: const Icon(Icons.email_outlined),
label: const Text('Email'),
style: OutlinedButton.styleFrom(
padding: const EdgeInsets.symmetric(vertical: 12),
),
),
),
const SizedBox(width: 12),
Expanded(
child: ElevatedButton.icon(
onPressed: () {
Navigator.pushAndRemoveUntil(
context,
MaterialPageRoute(builder: (context) => const ProductsScreen()),
(route) => false,
);
},
icon: const Icon(Icons.add),
label: const Text('New Sale'),
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFF2563EB),
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(vertical: 12),
),
),
),
],
),

const SizedBox(height: 16),
],
),
),
);
}

Widget _buildReceiptRow(String label, String value) {
return Padding(
padding: const EdgeInsets.symmetric(vertical: 4.0),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
label,
style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
),
Text(
value,
style: const TextStyle(fontWeight: FontWeight.w500),
),
],
),
);
}

Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
return Padding(
padding: const EdgeInsets.symmetric(vertical: 6.0),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
label,
style: TextStyle(
fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
fontSize: isTotal ? 16 : 14,
),
),
Text(
'\$${amount.toStringAsFixed(2)}',
style: TextStyle(
fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
fontSize: isTotal ? 18 : 14,
color: isTotal ? const Color(0xFF059669) : Colors.black,
),
),
],
),
);
}

String _formatDate(DateTime date) {
return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String _formatTime(DateTime date) {
return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

void _printReceipt(BuildContext context) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Print functionality to be implemented'),
behavior: SnackBarBehavior.floating,
),
);
}

void _emailReceipt(BuildContext context) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Email functionality to be implemented'),
behavior: SnackBarBehavior.floating,
),
);
}

void _shareReceipt(BuildContext context) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Share functionality to be implemented'),
behavior: SnackBarBehavior.floating,
),
);
}
}
