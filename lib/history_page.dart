import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Order {
  final String id;
  final DateTime date;
  final String from;
  final String to;
  final double price;
  final String status;
  final String serviceType;

  Order({
    required this.id,
    required this.date,
    required this.from,
    required this.to,
    required this.price,
    required this.status,
    required this.serviceType,
  });
}

class HistoryPage extends StatefulWidget {
  final bool autoReload;
  const HistoryPage({super.key, this.autoReload = false});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Order>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _futureOrders = _loadOrders();
    if (widget.autoReload) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _futureOrders = _loadOrders();
        });
      });
    }
  }

  Future<List<Order>> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('order_history') ?? [];
    return list.map((s) {
      final m = jsonDecode(s) as Map<String, dynamic>;
      return Order(
        id: m['id'] ?? '',
        date: DateTime.tryParse(m['date'] ?? '') ?? DateTime.now(),
        from: m['from'] ?? '',
        to: m['to'] ?? '',
        price: (m['price'] is num)
            ? (m['price'] as num).toDouble()
            : double.tryParse(m['price'].toString()) ?? 0.0,
        status: m['status'] ?? '',
        serviceType: m['service'] ?? 'motor',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: FutureBuilder<List<Order>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Text(
                'Belum ada riwayat pesanan.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _futureOrders = _loadOrders();
              });
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final o = orders[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: Icon(_getServiceIcon(o.serviceType),
                      size: 36,
                      color: Colors.blueAccent,
                    ),
                    title: Text('${o.from} → ${o.to}'),
                    subtitle: Text(
                      '${o.id} • ${_formatDate(o.date)}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rp ${o.price.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        _buildStatusChip(o.status),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderDetailPage(order: o),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // helper untuk memicu rebuild FutureBuilder saat pull-to-refresh
  void setStatePlaceholder(VoidCallback fn) => fn();

  String _formatDate(DateTime dt) {
    // format sederhana: dd/MM/yyyy HH:mm
    final d = dt;
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year;
    final hour = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$min';
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'selesai':
        color = Colors.green.shade100;
        break;
      case 'dibatalkan':
        color = Colors.red.shade100;
        break;
      default:
        color = Colors.grey.shade200;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: const TextStyle(fontSize: 12)),
    );
  }
}

IconData _getServiceIcon(String type) {
  switch (type.toLowerCase()) {
    case 'mobil':
      return Icons.directions_car;
    case 'motor':
      return Icons.two_wheeler;
    case 'pickup':
      return Icons.local_shipping;
    default:
      return Icons.help_outline;
  }
}

class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${order.id}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              'Waktu: ${order.date.toString()}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 8),
                Expanded(child: Text(order.from)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.flag),
                const SizedBox(width: 8),
                Expanded(child: Text(order.to)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Harga: Rp ${order.price.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Status: ${order.status}'),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            const Text('Catatan:'),
            const SizedBox(height: 8),
            Text(
              'Tidak ada catatan tambahan untuk pesanan ini.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
