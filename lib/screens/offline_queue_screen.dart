import 'package:flutter/material.dart';

class OfflineQueueScreen extends StatefulWidget {
  const OfflineQueueScreen({super.key});

  @override
  State<OfflineQueueScreen> createState() => _OfflineQueueScreenState();
}

class _OfflineQueueScreenState extends State<OfflineQueueScreen> {
  List<PendingTransaction> pendingTransactions = [
    PendingTransaction(
      id: '00126',
      amount: 45.00,
      date: DateTime(2025, 9, 27, 14, 35),
      status: SyncStatus.pending,
    ),
    PendingTransaction(
      id: '00127',
      amount: 32.50,
      date: DateTime(2025, 9, 27, 14, 40),
      status: SyncStatus.failed,
    ),
    PendingTransaction(
      id: '00128',
      amount: 28.75,
      date: DateTime(2025, 9, 27, 14, 45),
      status: SyncStatus.pending,
    ),
  ];

  bool isOnline = false;
  DateTime lastSync = DateTime(2025, 9, 27, 14, 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Queue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _syncAll,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection Status
            Card(
              color: isOnline ? Colors.green[50] : Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      isOnline ? Icons.wifi : Icons.wifi_off,
                      color: isOnline ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isOnline ? 'Online: Connected' : 'Connection: Offline',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isOnline ? Colors.green : Colors.orange,
                            ),
                          ),
                          Text(
                            'Last Sync: ${_formatDateTime(lastSync)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (!isOnline)
                      ElevatedButton(
                        onPressed: _retryConnection,
                        child: const Text('Retry Connection'),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Pending Transactions
            const Text(
              'Pending Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            if (pendingTransactions.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No pending transactions',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: pendingTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = pendingTransactions[index];
                    return _buildTransactionCard(transaction, index);
                  },
                ),
              ),

            // Sync All Button
            if (pendingTransactions.isNotEmpty && isOnline)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _syncAll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sync, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Sync All Transactions',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(PendingTransaction transaction, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${transaction.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '\$${transaction.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatDateTime(transaction.date),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStatusIndicator(transaction.status),
                const SizedBox(width: 8),
                Text(
                  _getStatusText(transaction.status),
                  style: TextStyle(
                    color: _getStatusColor(transaction.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (transaction.status == SyncStatus.failed)
                  ElevatedButton(
                    onPressed: () => _retryTransaction(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.refresh, size: 16),
                        SizedBox(width: 4),
                        Text('Retry'),
                      ],
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _deleteTransaction(index),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(SyncStatus status) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        shape: BoxShape.circle,
      ),
    );
  }

  Color _getStatusColor(SyncStatus status) {
    switch (status) {
      case SyncStatus.pending:
        return Colors.orange;
      case SyncStatus.syncing:
        return Colors.blue;
      case SyncStatus.completed:
        return Colors.green;
      case SyncStatus.failed:
        return Colors.red;
    }
  }

  String _getStatusText(SyncStatus status) {
    switch (status) {
      case SyncStatus.pending:
        return 'Pending Sync';
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.completed:
        return 'Completed';
      case SyncStatus.failed:
        return 'Sync Failed';
    }
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _syncAll() {
    setState(() {
      for (var transaction in pendingTransactions) {
        if (transaction.status != SyncStatus.completed) {
          transaction.status = SyncStatus.syncing;
        }
      }
    });

    // Simulate sync process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        for (var transaction in pendingTransactions) {
          if (transaction.status == SyncStatus.syncing) {
            transaction.status = SyncStatus.completed;
          }
        }
        lastSync = DateTime.now();
        isOnline = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All transactions synced successfully')),
      );
    });
  }

  void _retryConnection() {
    setState(() {
      isOnline = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connection restored')),
    );
  }

  void _retryTransaction(int index) {
    setState(() {
      pendingTransactions[index].status = SyncStatus.syncing;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        pendingTransactions[index].status = SyncStatus.completed;
      });
    });
  }

  void _deleteTransaction(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                pendingTransactions.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaction deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class PendingTransaction {
  final String id;
  final double amount;
  final DateTime date;
  SyncStatus status;

  PendingTransaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
  });
}

enum SyncStatus {
  pending,
  syncing,
  completed,
  failed,
}// TODO Implement this library.