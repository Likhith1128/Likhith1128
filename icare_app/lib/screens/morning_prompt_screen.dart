import 'package:flutter/material.dart';

import '../models.dart';
import '../navigation.dart';
import '../prompts.dart';
import '../study_scope.dart';
import '../widgets/hold_button.dart';
import '../widgets/study_scaffold.dart';

class MorningPromptScreen extends StatelessWidget {
  const MorningPromptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StudyScope.watch(context).controller;
    final message = morningPrompt(controller.group, controller.goalPhrase);

    return StudyScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TimeBand(
              time: formatClock(controller.morningMinutes),
              message: 'Good morning',
            ),
            const SizedBox(height: 20),
            const PromptCard(
              child: Text('You are taking part in the I-CARE study.'),
            ),
            const SizedBox(height: 16),
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
              key: const Key('prompt-got-it'),
              label: 'Got it!',
              icon: Icons.check,
              waitToRead: true,
              onPressed: () {
                controller.acknowledgeMorning();
                openHome(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
