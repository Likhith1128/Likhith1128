import 'package:flutter/material.dart';

import '../navigation.dart';
import '../theme.dart';
import 'hold_button.dart';

class StudyScaffold extends StatelessWidget {
  const StudyScaffold({
    super.key,
    required this.body,
    this.title,
    this.showHome = true,
    this.showBack = true,
  });

  final Widget body;
  final String? title;
  final bool showHome;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showHome || showBack) ...[
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    if (showBack)
                      HoldButton(
                        label: 'Back',
                        icon: Icons.arrow_back,
                        compact: true,
                        style: HoldStyle.secondary,
                        onPressed: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            openHome(context);
                          }
                        },
                      )
                    else
                      const SizedBox(width: 8),
                    if (showHome)
                      HoldButton(
                        label: 'Home',
                        icon: Icons.home_outlined,
                        compact: true,
                        style: HoldStyle.secondary,
                        onPressed: () => openHome(context),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
              if (title != null) ...[
                Text(title!, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
              ],
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

class PromptCard extends StatelessWidget {
  const PromptCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: StudyColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: StudyColors.line, width: 2),
      ),
      child: Padding(padding: const EdgeInsets.all(24), child: child),
    );
  }
}

class TimeBand extends StatelessWidget {
  const TimeBand({super.key, required this.time, required this.message});

  final String time;
  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: StudyColors.night,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(color: Colors.white, fontSize: 48),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
