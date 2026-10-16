import 'package:flutter/material.dart';

import '../models.dart';
import '../prompts.dart';
import '../study_scope.dart';
import '../widgets/hold_button.dart';
import '../widgets/study_scaffold.dart';

class DuringPromptScreen extends StatelessWidget {
  const DuringPromptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StudyScope.watch(context).controller;
    final message = duringPrompt(controller.group, controller.goalPhrase);
    final now = TimeOfDay.now();

    return StudyScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TimeBand(
              time: formatClock((now.hour * 60) + now.minute),
              message: watchCue,
            ),
            const SizedBox(height: 20),
            PromptCard(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 20),
            Text(seenInstruction, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            HoldButton(
              key: const Key('during-got-it'),
              label: 'Got it!',
              icon: Icons.check,
              waitToRead: true,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/active');
              },
            ),
          ],
        ),
      ),
    );
  }
}
