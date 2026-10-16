import 'dart:async';

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

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final route = ModalRoute.of(context);
      if (route != null && !route.isCurrent) return;
      setState(() {});
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
}
