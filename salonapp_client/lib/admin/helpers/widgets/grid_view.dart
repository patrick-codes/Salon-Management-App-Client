import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../presentation/metrics/bloc/repository/model/metrics service/metrics_service.dart';
import 'cedi_sign.dart';

class GridViewComponent extends StatelessWidget {
  final String ownerId;
  const GridViewComponent({Key? key, required this.ownerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cedi = CediSign();
    return FutureBuilder<Map<String, dynamic>>(
      future: MetricsService.fetchSalonMetrics(ownerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Text("No metrics available");
        }

        final metrics = snapshot.data!;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildMetricCard("Orders", metrics['totalOrders'].toString()),
            _buildMetricCard(
                "Revenue", "GHS${metrics['totalRevenue']!.toStringAsFixed(2)}"),
            _buildMetricCard("Customers", metrics['totalCustomers'].toString()),
            _buildMetricCard("Services", metrics['totalServices'].toString()),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
