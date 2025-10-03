
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'products_screen.dart';
import 'reports_screen.dart';
import 'offline_queue_screen.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends StatelessWidget {
const DashboardScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Dashboard'),
actions: [
IconButton(
icon: const Icon(Icons.notifications_outlined),
onPressed: () {},
tooltip: 'Notifications',
),
IconButton(
icon: const Icon(Icons.person_outline),
onPressed: () {},
tooltip: 'Profile',
),
],
),
drawer: _buildDrawer(context),
body: SingleChildScrollView(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Welcome Section
Card(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Row(
children: [
CircleAvatar(
radius: 24,
backgroundColor: Colors.blue[50],
child: const Icon(Icons.person, color: Color(0xFF2563EB)),
),
const SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Welcome back!',
style: Theme.of(context).textTheme.titleMedium?.copyWith(
fontWeight: FontWeight.bold,
),
),
Text(
'Ready to serve your customers?',
style: Theme.of(context).textTheme.bodyMedium?.copyWith(
color: Colors.grey[600],
),
),
],
),
),
Container(
padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
decoration: BoxDecoration(
color: Colors.green[50],
borderRadius: BorderRadius.circular(20),
border: Border.all(color: Colors.green),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(Icons.circle, size: 8, color: Colors.green[700]),
const SizedBox(width: 4),
Text(
'Online',
style: TextStyle(
color: Colors.green[700],
fontSize: 12,
fontWeight: FontWeight.w500,
),
),
],
),
),
],
),
),
),

const SizedBox(height: 24),

// Quick Actions
Text(
'Quick Actions',
style: Theme.of(context).textTheme.titleLarge?.copyWith(
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 16),
SizedBox(
height: 100, // Fixed height to prevent overflow
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
_buildActionButton(
icon: Icons.shopping_cart_outlined,
label: 'New Sale',
color: const Color(0xFF2563EB),
onTap: () => Navigator.push(
context,
MaterialPageRoute(builder: (context) => const ProductsScreen()),
),
),
_buildActionButton(
icon: Icons.bar_chart_outlined,
label: 'Reports',
color: const Color(0xFF059669),
onTap: () => Navigator.push(
context,
MaterialPageRoute(builder: (context) => const ReportsScreen()),
),
),
_buildActionButton(
icon: Icons.inventory_2_outlined,
label: 'Products',
color: const Color(0xFFDC2626),
onTap: () => Navigator.push(
context,
MaterialPageRoute(builder: (context) => const ProductsScreen()),
),
),
_buildActionButton(
icon: Icons.sync_outlined,
label: 'Sync',
color: const Color(0xFF7C3AED),
onTap: () => Navigator.push(
context,
MaterialPageRoute(builder: (context) => const OfflineQueueScreen()),
),
),
],
),
),

const SizedBox(height: 24),

// Today's Summary
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
"Today's Summary",
style: Theme.of(context).textTheme.titleLarge?.copyWith(
fontWeight: FontWeight.bold,
),
),
Text(
'Today',
style: TextStyle(
color: Colors.grey[600],
),
),
],
),
const SizedBox(height: 16),
const SummaryCard(
title: 'Sales Overview',
items: {
'Total Sales': 'MWK 1,250.00',
'Transactions': '24 orders',
'Pending Sync': '3 transactions',
'Avg. Order': 'MWK 52.08',
},
color: Colors.green,
),

const SizedBox(height: 24),

// Recent Transactions
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
'Recent Transactions',
style: Theme.of(context).textTheme.titleLarge?.copyWith(
fontWeight: FontWeight.bold,
),
),
TextButton(
onPressed: () {},
child: const Text('View All'),
),
],
),
const SizedBox(height: 8),

// Fixed height for transactions list to prevent overflow
ConstrainedBox(
constraints: BoxConstraints(
maxHeight: MediaQuery.of(context).size.height * 0.4, // 40% of screen height
minHeight: 200, // Minimum height
),
child: ListView(
shrinkWrap: true,
physics: const AlwaysScrollableScrollPhysics(),
children: [
_buildTransactionItem('Order #001', 'MWK 45.00', Icons.check_circle, Colors.green, 'Completed'),
_buildTransactionItem('Order #002', 'MWK 32.50', Icons.sync, Colors.orange, 'Syncing'),
_buildTransactionItem('Order #003', 'MWK 28.75', Icons.check_circle, Colors.green, 'Completed'),
_buildTransactionItem('Order #004', 'MWK 52.25', Icons.check_circle, Colors.green, 'Completed'),
_buildTransactionItem('Order #005', 'MWK 67.80', Icons.pending, Colors.blue, 'Pending'),
_buildTransactionItem('Order #006', 'MWK 42.30', Icons.check_circle, Colors.green, 'Completed'),
_buildTransactionItem('Order #007', 'MWK 89.15', Icons.check_circle, Colors.green, 'Completed'),
],
),
),
],
),
),
floatingActionButton: FloatingActionButton(
onPressed: () => Navigator.push(
context,
MaterialPageRoute(builder: (context) => const ProductsScreen()),
),
backgroundColor: const Color(0xFF2563EB),
foregroundColor: Colors.white,
elevation: 4,
child: const Icon(Icons.add),
),
);
}

Widget _buildDrawer(BuildContext context) {
return Drawer(
child: Column(
children: [
// Drawer Header
Container(
width: double.infinity,
padding: const EdgeInsets.all(16),
decoration: const BoxDecoration(
color: Color(0xFF2563EB),
),
child: SafeArea(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const CircleAvatar(
radius: 30,
backgroundColor: Colors.white,
child: Icon(Icons.restaurant, color: Color(0xFF2563EB), size: 30),
),
const SizedBox(height: 12),
const Text(
'Mpepo Kitchen',
style: TextStyle(
color: Colors.white,
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 4),
Text(
'user@mpepo.com',
style: TextStyle(
color: Colors.white.withOpacity(0.8),
fontSize: 14,
),
),
const SizedBox(height: 8),
Container(
padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
decoration: BoxDecoration(
color: Colors.white.withOpacity(0.2),
borderRadius: BorderRadius.circular(12),
),
child: const Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(Icons.circle, size: 8, color: Colors.white),
SizedBox(width: 4),
Text(
'Online',
style: TextStyle(
color: Colors.white,
fontSize: 12,
),
),
],
),
),
],
),
),
),

// Drawer Menu Items
Expanded(
child: ListView(
padding: EdgeInsets.zero,
children: [
_buildDrawerItem(
context,
icon: Icons.dashboard_outlined,
title: 'Dashboard',
selected: true,
onTap: () => Navigator.pop(context),
),
_buildDrawerItem(
context,
icon: Icons.shopping_cart_outlined,
title: 'New Sale',
onTap: () {
Navigator.pop(context);
Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsScreen()));
},
),
_buildDrawerItem(
context,
icon: Icons.inventory_2_outlined,
title: 'Products',
onTap: () {
Navigator.pop(context);
Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsScreen()));
},
),
_buildDrawerItem(
context,
icon: Icons.bar_chart_outlined,
title: 'Reports',
onTap: () {
Navigator.pop(context);
Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsScreen()));
},
),
_buildDrawerItem(
context,
icon: Icons.sync_outlined,
title: 'Offline Queue',
onTap: () {
Navigator.pop(context);
Navigator.push(context, MaterialPageRoute(builder: (context) => const OfflineQueueScreen()));
},
),
const Divider(),
_buildDrawerItem(
context,
icon: Icons.settings_outlined,
title: 'Settings',
onTap: () {},
),
_buildDrawerItem(
context,
icon: Icons.help_outline,
title: 'Help & Support',
onTap: () {},
),
_buildDrawerItem(
context,
icon: Icons.logout_outlined,
title: 'Logout',
onTap: () {
Navigator.pop(context);
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
},
),
],
),
),
],
),
);
}

Widget _buildDrawerItem(BuildContext context, {
required IconData icon,
required String title,
bool selected = false,
required VoidCallback onTap,
}) {
return ListTile(
leading: Icon(icon, color: selected ? const Color(0xFF2563EB) : Colors.grey[700]),
title: Text(
title,
style: TextStyle(
color: selected ? const Color(0xFF2563EB) : Colors.grey[700],
fontWeight: selected ? FontWeight.bold : FontWeight.normal,
),
),
trailing: selected ? const Icon(Icons.circle, size: 8, color: Color(0xFF2563EB)) : null,
onTap: onTap,
);
}

Widget _buildActionButton({
required IconData icon,
required String label,
required Color color,
required VoidCallback onTap,
}) {
return GestureDetector(
onTap: onTap,
child: Column(
children: [
Container(
width: 64,
height: 64,
decoration: BoxDecoration(
color: color.withOpacity(0.1),
borderRadius: BorderRadius.circular(16),
border: Border.all(color: color.withOpacity(0.2)),
),
child: Icon(icon, color: color, size: 28),
),
const SizedBox(height: 8),
Text(
label,
style: TextStyle(
fontWeight: FontWeight.w500,
color: Colors.grey[700],
),
textAlign: TextAlign.center,
),
],
),
);
}

Widget _buildTransactionItem(String order, String amount, IconData icon, Color color, String status) {
return Card(
margin: const EdgeInsets.only(bottom: 8),
child: ListTile(
leading: Container(
width: 40,
height: 40,
decoration: BoxDecoration(
color: color.withOpacity(0.1),
borderRadius: BorderRadius.circular(8),
),
child: Icon(icon, color: color, size: 20),
),
title: Text(order, style: const TextStyle(fontWeight: FontWeight.w500)),
subtitle: Text(status, style: TextStyle(color: Colors.grey[600])),
trailing: Column(
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.end,
children: [
Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
Text('Today', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
],
),
onTap: () {},
),
);
}
}
