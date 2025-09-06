class DashboardMetric {
  final String title;
  final String amount;
  final String previousPercent;
  final bool isGrowth; // to decide green/red arrow

  DashboardMetric({
    required this.title,
    required this.amount,
    required this.previousPercent,
    required this.isGrowth,
  });
}
