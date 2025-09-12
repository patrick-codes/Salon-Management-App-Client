// metrics_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'metrics_event.dart';
import 'repository/model/metrics_model.dart';

class MetricsBloc extends Bloc<MetricsEvent, MetricsState> {
  MetricsBloc() : super(MetricsLoading()) {
    on<LoadMetrics>((event, emit) async {
      try {
        // 🔥 Fetch from Firestore
        // Example: revenue, orders, customers, growth
        final metrics = [
          DashboardMetric(
            title: "Revenue",
            amount: "34,452",
            previousPercent: "2.65%",
            isGrowth: false,
          ),
          DashboardMetric(
            title: "Orders",
            amount: "5,643",
            previousPercent: "0.82%",
            isGrowth: true,
          ),
        ];

        emit(MetricsLoaded(metrics));
      } catch (e) {
        emit(MetricsError(e.toString()));
      }
    });
  }
}
