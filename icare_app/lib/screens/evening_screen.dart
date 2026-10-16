import 'package:flutter/material.dart';

import '../models.dart';
import '../navigation.dart';
import '../prompts.dart';
import '../study_scope.dart';
import '../theme.dart';
import '../widgets/hold_button.dart';
import '../widgets/study_scaffold.dart';

class EveningScreen extends StatefulWidget {
  const EveningScreen({super.key});

  @override
  State<EveningScreen> createState() => _EveningScreenState();
}

class _EveningScreenState extends State<EveningScreen> {
  late int _count;
  late List<int> _minutes;
  var _ready = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ready) return;
    _ready = true;
    final controller = StudyScope.watch(context).controller;
    final saved = controller.todayReport;
    if (saved != null) {
      _count = saved.count;
      _minutes = [...saved.minutes];
    } else {
      final bouts = controller.completedToday;
      _count = bouts.length;
      _minutes = [for (final bout in bouts) _minutesFor(bout)];
    }
    _fitMinutes();
  }

  int _minutesFor(ActivityBout bout) {
    final ended = bout.endedAt;
    if (ended == null) return 30;
    final minutes = ended.difference(bout.startedAt).inMinutes;
    if (minutes < 5) return 5;
    if (minutes > 300) return 300;
    return minutes;
  }

  void _fitMinutes() {
    if (_minutes.length < _count) {
      _minutes = [
        ..._minutes,
        for (var i = _minutes.length; i < _count; i++) 30,
      ];
    } else if (_minutes.length > _count) {
      _minutes = _minutes.take(_count).toList();
    }
  }

  void _changeCount(int next) {
    setState(() {
      _count = next.clamp(0, 12);
      _fitMinutes();
    });
  }

  void _changeMinutes(int index, int delta) {
    setState(() {
      _minutes[index] = (_minutes[index] + delta).clamp(5, 300);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = StudyScope.watch(context).controller;
    final theme = Theme.of(context);

    return StudyScaffold(
      title: 'End of day',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Around ${formatClock(controller.bedMinutes)}, based on your bedtime.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: StudyColors.muted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(eveningCountQuestion, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 12),
                  Text(
                    '$_count',
                    key: const Key('exercise-count'),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  HoldButton(
                    key: const Key('count-plus'),
                    label: 'More',
                    icon: Icons.add,
                    style: HoldStyle.secondary,
                    onPressed: _count == 12
                        ? null
                        : () => _changeCount(_count + 1),
                  ),
                  HoldButton(
                    key: const Key('count-minus'),
                    label: 'Fewer',
                    icon: Icons.remove,
                    style: HoldStyle.secondary,
                    onPressed: _count == 0
                        ? null
                        : () => _changeCount(_count - 1),
                  ),
                  if (_count > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      'How long was each one?',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    for (var index = 0; index < _count; index++) ...[
                      Text(
                        'Exercise ${index + 1}',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_minutes[index]} min',
                        key: Key('minutes-$index'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      HoldButton(
                        key: Key('minutes-plus-$index'),
                        label: 'More time',
                        icon: Icons.add,
                        style: HoldStyle.secondary,
                        onPressed: () => _changeMinutes(index, 5),
                      ),
                      HoldButton(
                        key: Key('minutes-minus-$index'),
                        label: 'Less time',
                        icon: Icons.remove,
                        style: HoldStyle.secondary,
                        onPressed: () => _changeMinutes(index, -5),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          HoldButton(
            key: const Key('save-evening'),
            label: 'Save',
            icon: Icons.check,
            waitToRead: true,
            onPressed: () {
              controller.saveDayReport(count: _count, minutes: _minutes);
              openHome(context);
            },
          ),
        ],
      ),
    );
  }
}
