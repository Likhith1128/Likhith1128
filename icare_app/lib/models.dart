enum StudyGroup {
  exerciseGoals('Exercise goals'),
  awareness('Awareness'),
  distraction('Distraction');

  const StudyGroup(this.label);

  final String label;

  static StudyGroup byName(String? name) {
    for (final group in StudyGroup.values) {
      if (group.name == name) return group;
    }
    return StudyGroup.exerciseGoals;
  }
}

enum FontChoice {
  medium('Medium', 1),
  large('Large', 1.15),
  extraLarge('Extra large', 1.35);

  const FontChoice(this.label, this.scale);

  final String label;
  final double scale;

  static FontChoice byName(String? name) {
    for (final choice in FontChoice.values) {
      if (choice.name == name) return choice;
    }
    return FontChoice.large;
  }
}

enum ActivityKind {
  biking('Biking'),
  running('Running'),
  weightTraining('Weight training'),
  swimming('Swimming'),
  other('Other');

  const ActivityKind(this.label);

  final String label;

  static ActivityKind? byName(String? name) {
    for (final kind in ActivityKind.values) {
      if (kind.name == name) return kind;
    }
    return null;
  }
}

enum Frequency {
  never('Never'),
  seldom('Seldom'),
  sometimes('Sometimes'),
  often('Often'),
  almostAlways('Almost Always');

  const Frequency(this.label);

  final String label;

  static Frequency? byName(String? name) {
    for (final frequency in Frequency.values) {
      if (frequency.name == name) return frequency;
    }
    return null;
  }
}

class ActivityBout {
  ActivityBout({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.activity,
    this.otherDetail,
    this.rating,
  });

  final String id;
  final DateTime startedAt;
  DateTime? endedAt;
  ActivityKind? activity;
  String? otherDetail;
  Frequency? rating;

  bool get isOpen => endedAt == null;

  bool get reportComplete {
    if (endedAt == null || activity == null || rating == null) return false;
    if (activity == ActivityKind.other) {
      return otherDetail != null && otherDetail!.trim().isNotEmpty;
    }
    return true;
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'activity': activity?.name,
      'otherDetail': otherDetail,
      'rating': rating?.name,
    };
  }

  static ActivityBout? fromJson(Object? value) {
    if (value is! Map) return null;
    final id = value['id'];
    final started = value['startedAt'];
    if (id is! String || started is! String) return null;
    final startedAt = DateTime.tryParse(started);
    if (startedAt == null) return null;
    final endedRaw = value['endedAt'];
    return ActivityBout(
      id: id,
      startedAt: startedAt,
      endedAt: endedRaw is String ? DateTime.tryParse(endedRaw) : null,
      activity: ActivityKind.byName(value['activity'] as String?),
      otherDetail: value['otherDetail'] as String?,
      rating: Frequency.byName(value['rating'] as String?),
    );
  }
}

class DayReport {
  const DayReport({required this.count, required this.minutes});

  final int count;
  final List<int> minutes;

  Map<String, Object> toJson() => {'count': count, 'minutes': minutes};

  static DayReport? fromJson(Object? value) {
    if (value is! Map) return null;
    final count = value['count'];
    final minutes = value['minutes'];
    if (count is! num || minutes is! List) return null;
    return DayReport(
      count: count.toInt(),
      minutes: [
        for (final item in minutes)
          if (item is num) item.toInt(),
      ],
    );
  }
}

String dayKey(DateTime time) {
  final local = time.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
}

String formatClock(int minutesFromMidnight) {
  final bounded = minutesFromMidnight.clamp(0, (24 * 60) - 1);
  final hour24 = bounded ~/ 60;
  final minute = bounded % 60;
  final period = hour24 >= 12 ? 'PM' : 'AM';
  final hour = hour24 % 12 == 0 ? 12 : hour24 % 12;
  return '$hour:${minute.toString().padLeft(2, '0')} $period';
}

String formatElapsed(Duration duration) {
  final safe = duration.isNegative ? Duration.zero : duration;
  final hours = safe.inHours;
  final minutes = safe.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = safe.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (hours > 0) return '$hours:$minutes:$seconds';
  return '$minutes:$seconds';
}
