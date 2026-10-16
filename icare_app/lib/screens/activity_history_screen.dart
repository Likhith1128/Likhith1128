import 'package:flutter/material.dart';

import '../models.dart';
import '../study_scope.dart';
import '../theme.dart';
import '../widgets/study_scaffold.dart';

class ActivityHistoryScreen extends StatelessWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = StudyScope.watch(context).controller.completedToday;
    final theme = Theme.of(context);

    return StudyScaffold(
      title: 'Activity history',
      body: activities.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.directions_walk_outlined,
                      size: 64,
                      color: StudyColors.muted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No activities logged today',
                      key: const Key('activity-history-empty'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Completed activities will appear here.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: StudyColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              key: const Key('activity-history-list'),
              itemCount: activities.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _ActivityCard(activity: activity, index: index);
              },
            ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity, required this.index});

  final ActivityBout activity;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final endedAt = activity.endedAt;
    final label = activity.activity?.label ?? 'Activity';
    final title = activity.activity == ActivityKind.other &&
            activity.otherDetail?.isNotEmpty == true
        ? activity.otherDetail!
        : label;
    final duration = endedAt == null
        ? 'In progress'
        : _durationLabel(endedAt.difference(activity.startedAt));
    final details = [
      '${formatClock(activity.startedAt.hour * 60 + activity.startedAt.minute)}'
          '${endedAt == null ? '' : ' – ${formatClock(endedAt.hour * 60 + endedAt.minute)}'}',
      duration,
      if (activity.rating != null) 'Frequency: ${activity.rating!.label}',
    ];

    return Card(
      key: Key('activity-history-item-$index'),
      margin: EdgeInsets.zero,
      color: StudyColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: StudyColors.line, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFE5F2EB),
              foregroundColor: StudyColors.greenDark,
              child: Icon(Icons.directions_walk),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  for (var i = 0; i < details.length; i++) ...[
                    if (i > 0) const SizedBox(height: 3),
                    Text(
                      details[i],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: StudyColors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _durationLabel(Duration duration) {
    final minutes = duration.inMinutes;
    if (minutes <= 0) return 'Under 1 min';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours == 0) return '$minutes min';
    if (remainingMinutes == 0) return '${hours}h';
    return '${hours}h ${remainingMinutes}m';
  }
}
