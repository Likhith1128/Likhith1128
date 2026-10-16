import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models.dart';
import '../study_scope.dart';
import '../theme.dart';
import '../widgets/hold_button.dart';
import '../widgets/study_scaffold.dart';

class ActiveBoutScreen extends StatefulWidget {
  const ActiveBoutScreen({super.key});

  @override
  State<ActiveBoutScreen> createState() => _ActiveBoutScreenState();
}

class _ActiveBoutScreenState extends State<ActiveBoutScreen> {
  Timer? _ticker;
  int _heartRateElapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final route = ModalRoute.of(context);
      if (route != null && !route.isCurrent) return;
      setState(() => _heartRateElapsedSeconds++);
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = StudyScope.watch(context).controller;
    final bout = controller.activeBout;
    final theme = Theme.of(context);

    return StudyScaffold(
      title: 'Current activity',
      body: bout == null
          ? Center(
              child: Text(
                'No activity is in progress.',
                style: theme.textTheme.bodyLarge,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const PromptCard(
                        child: Text(
                          'This screen tracks the current bout of physical activity.',
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        formatElapsed(
                          DateTime.now().difference(bout.startedAt),
                        ),
                        key: const Key('elapsed-time'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 64,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _HeartRateCard(
                        beatsPerMinute: _simulatedHeartRate(
                          _heartRateElapsedSeconds,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Started at ${formatClock((bout.startedAt.hour * 60) + bout.startedAt.minute)}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: StudyColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                HoldButton(
                  key: const Key('end-bout'),
                  label: 'End',
                  icon: Icons.stop_rounded,
                  style: HoldStyle.danger,
                  onPressed: () => Navigator.of(context).pushNamed('/end'),
                ),
              ],
            ),
    );
  }

  int _simulatedHeartRate(int elapsedSeconds) {
    final variation =
        18 * math.sin(elapsedSeconds / 7) + 6 * math.sin(elapsedSeconds / 2.7);
    return (85 + variation).round();
  }
}

class _HeartRateCard extends StatelessWidget {
  const _HeartRateCard({required this.beatsPerMinute});

  final int beatsPerMinute;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      key: const Key('heart-rate-card'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: StudyColors.clay.withValues(alpha: 0.45),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, color: StudyColors.clay, size: 26),
              const SizedBox(width: 8),
              Text('Heart rate', style: theme.textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$beatsPerMinute',
                key: const Key('heart-rate-value'),
                style: theme.textTheme.headlineMedium?.copyWith(fontSize: 42),
              ),
              const SizedBox(width: 8),
              Text('BPM', style: theme.textTheme.bodyLarge),
            ],
          ),
          Text(
            'Demo data · simulated until a watch is connected',
            key: const Key('heart-rate-demo-label'),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: StudyColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
