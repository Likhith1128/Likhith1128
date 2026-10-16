import 'package:flutter/material.dart';

import '../prompts.dart';
import '../study_scope.dart';
import '../widgets/hold_button.dart';
import '../widgets/study_scaffold.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StudyScope.watch(context).controller;

    return StudyScaffold(
      showHome: false,
      showBack: false,
      title: 'Welcome to the study',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                Text(
                  welcomeMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Text(
                  'Hold each button briefly. A light tap will not continue.',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: const Color(0xFF5C6570)),
                ),
              ],
            ),
          ),
          HoldButton(
            key: const Key('welcome-continue'),
            label: 'Continue',
            icon: Icons.arrow_forward,
            waitToRead: true,
            onPressed: () {
              controller.completeWelcome();
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
        ],
      ),
    );
  }
}
