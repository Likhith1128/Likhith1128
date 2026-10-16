import 'package:flutter/material.dart';

import '../navigation.dart';
import '../study_scope.dart';
import '../widgets/hold_button.dart';
import '../widgets/study_scaffold.dart';

class BeginActivityScreen extends StatelessWidget {
  const BeginActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StudyScope.watch(context).controller;

    return StudyScaffold(
      title: 'Are you beginning physical activity?',
      body: ListView(
        children: [
          const SizedBox(height: 24),
          HoldButton(
            key: const Key('begin-yes'),
            label: 'Yes',
            icon: Icons.check,
            waitToRead: true,
            onPressed: () {
              controller.startBout();
              Navigator.of(context).pushReplacementNamed('/during');
            },
          ),
          HoldButton(
            key: const Key('begin-no'),
            label: 'No',
            icon: Icons.close,
            style: HoldStyle.secondary,
            waitToRead: true,
            onPressed: () => openHome(context),
          ),
        ],
      ),
    );
  }
}
