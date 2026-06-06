enum TimelineStatus { completed, active, upcoming }

class TimelineStepModel {
  final String title;
  final String subtitle;
  final TimelineStatus status;

  TimelineStepModel({
    required this.title,
    required this.subtitle,
    required this.status,
  });
}
