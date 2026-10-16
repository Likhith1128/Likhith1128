import 'package:flutter/material.dart';

import '../navigation.dart';
import '../study_scope.dart';
import '../widgets/hold_button.dart';
import '../widgets/study_scaffold.dart';

class EndConfirmScreen extends StatelessWidget {
  const EndConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StudyScope.watch(context).controller;

    return StudyScaffold(
      title: 'Would you like to end your exercise?',
      body: ListView(
        children: [
          const SizedBox(height: 24),
          HoldButton(
            key: const Key('end-no'),
            label: 'No',
            icon: Icons.close,
            style: HoldStyle.secondary,
            waitToRead: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
          HoldButton(
            key: const Key('end-yes'),
            label: 'Yes',
            icon: Icons.check,
            waitToRead: true,
            onPressed: () {
              controller.finishBout();
              openOnTopOfHome(context, '/post');
            },
          ),
        ],
      ),
    );
  }
}
