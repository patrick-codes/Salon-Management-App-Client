// metrics_event.dart
import 'repository/model/metrics_model.dart';

abstract class MetricsEvent {}

class LoadMetrics extends MetricsEvent {}

// metrics_state.dart
abstract class MetricsState {}

class MetricsLoading extends MetricsState {}

class MetricsLoaded extends MetricsState {
  final List<DashboardMetric> metrics;
  MetricsLoaded(this.metrics);
}

class MetricsError extends MetricsState {
  final String message;
  MetricsError(this.message);
}
