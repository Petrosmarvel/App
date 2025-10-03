
import 'package:flutter/material.dart';
import '../widgets/summary_card.dart';

class ReportsScreen extends StatefulWidget {
const ReportsScreen({super.key});

@override
State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
DateTime selectedDate = DateTime.now();
Map<String, double> dailySales = {
'Mon': 450.0,
'Tue': 280.0,
'Wed': 320.0,
'Thu': 380.0,
'Fri': 520.0,
'Sat': 610.0,
'Sun': 390.0,
};

double get maxSales => dailySales.values.reduce((a, b) => a > b ? a : b);

@override
Widget build(BuildContext context) {
final totalSales = dailySales.values.fold(0.0, (sum, value) => sum + value);
final averageSales = totalSales / dailySales.length;
final totalTax = totalSales * 0.10;

return Scaffold(
appBar: AppBar(
title: const Text('Sales Reports'),
actions: [
IconButton(
icon: const Icon(Icons.calendar_today),
onPressed: _selectDate,
),
],
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Date Selector
Card(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Row(
children: [
const Text('Period: ', style: TextStyle(fontWeight: FontWeight.bold)),
Text(
'${_formatMonth(selectedDate)} ${selectedDate.year}',
style: const TextStyle(fontSize: 16),
),
const Spacer(),
ElevatedButton.icon(
onPressed: _exportCSV,
icon: const Icon(Icons.file_download),
label: const Text('Export CSV'),
),
],
),
),
),
const SizedBox(height: 16),

// Sales Chart
Card(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Weekly Sales Chart',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 16),
SizedBox(
height: 200,
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
crossAxisAlignment: CrossAxisAlignment.end,
children: dailySales.entries.map((entry) {
final height = (entry.value / maxSales) * 150;
return Column(
children: [
Text(
'MWK ${entry.value.toInt()}',
style: const TextStyle(fontSize: 12),
),
const SizedBox(height: 4),
Container(
width: 30,
height: height,
decoration: BoxDecoration(
color: const Color(0xFF2563EB),
borderRadius: BorderRadius.circular(4),
),
),
const SizedBox(height: 4),
Text(
entry.key,
style: const TextStyle(
fontWeight: FontWeight.bold,
fontSize: 12,
),
),
],
);
}).toList(),
),
),
],
),
),
),
const SizedBox(height: 16),

// Summary Cards
const Text(
'Sales Summary',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 12),
SummaryCard(
title: 'Monthly Overview',
items: {
'Total Sales': 'MWK ${totalSales.toStringAsFixed(2)}',
'Total Tax': 'MWK ${totalTax.toStringAsFixed(2)}',
'Average Daily': 'MWK ${averageSales.toStringAsFixed(2)}',
'Transactions': '42',
},
color: const Color(0xFF2563EB),
),
const SizedBox(height: 12),
SummaryCard(
title: 'Product Performance',
items: {
'Top Product': 'Burger (125 sold)',
'Revenue Leader': 'Pizza (MWK 1,895)',
'Category Split': 'Food: 65%, Drinks: 35%',
},
color: const Color(0xFF059669),
),

const SizedBox(height: 16),

// Recent Transactions Table
Card(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Recent Transactions',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 12),

// Fixed height for transactions list
SizedBox(
height: 300, // Fixed height to prevent overflow
child: ListView.builder(
itemCount: 10,
itemBuilder: (context, index) {
return ListTile(
leading: const Icon(Icons.receipt, color: Colors.green),
title: Text('Order #${1000 + index}'),
subtitle: Text('2025-09-${20 + index} • MWK ${(50 + index * 10).toDouble()}'),
trailing: const Icon(Icons.chevron_right),
);
},
),
),
],
),
),
),

const SizedBox(height: 16), // Extra spacing at the bottom
],
),
),
);
}

Future<void> _selectDate() async {
final DateTime? picked = await showDatePicker(
context: context,
initialDate: selectedDate,
firstDate: DateTime(2020),
lastDate: DateTime(2030),
);
if (picked != null && picked != selectedDate) {
setState(() {
selectedDate = picked;
});
}
}

String _formatMonth(DateTime date) {
return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1];
}

void _exportCSV() {
// TODO: Implement CSV export
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('CSV export functionality to be implemented')),
);
}
}
