import 'package:flutter/material.dart';

import 'screens/active_bout_screen.dart';
import 'screens/begin_activity_screen.dart';
import 'screens/during_prompt_screen.dart';
import 'screens/end_confirm_screen.dart';
import 'screens/evening_screen.dart';
import 'screens/home_screen.dart';
import 'screens/morning_prompt_screen.dart';
import 'screens/post_activity_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/welcome_screen.dart';
import 'study_controller.dart';
import 'study_scope.dart';
import 'theme.dart';

class ICareApp extends StatelessWidget {
  const ICareApp({
    super.key,
    required this.controller,
    this.timing = StudyTiming.participant,
  });

  final StudyController controller;
  final StudyTiming timing;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I-CARE',
      debugShowCheckedModeBanner: false,
      theme: buildStudyTheme(),
      initialRoute: controller.welcomed ? '/home' : '/',
      routes: {
        '/': (_) => const WelcomeScreen(),
        '/home': (_) => const HomeScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/morning': (_) => const MorningPromptScreen(),
        '/begin': (_) => const BeginActivityScreen(),
        '/during': (_) => const DuringPromptScreen(),
        '/active': (_) => const ActiveBoutScreen(),
        '/end': (_) => const EndConfirmScreen(),
        '/post': (_) => const PostActivityScreen(),
        '/evening': (_) => const EveningScreen(),
      },
      builder: (context, child) {
        return ListenableBuilder(
          listenable: controller,
          builder: (context, navigator) {
            final media = MediaQuery.of(context);
            final scale =
                (media.textScaler.scale(1) * controller.fontChoice.scale).clamp(
                  1.0,
                  2.2,
                );
            return StudyScope(
              controller: controller,
              timing: timing,
              child: MediaQuery(
                data: media.copyWith(textScaler: TextScaler.linear(scale)),
                child: ColoredBox(
                  color: StudyColors.frame,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: navigator!,
                    ),
                  ),
                ),
              ),
            );
          },
          child: child,
        );
      },
    );
  }
}
