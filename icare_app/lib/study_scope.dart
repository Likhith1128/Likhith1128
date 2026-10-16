import 'package:flutter/widgets.dart';

import 'study_controller.dart';

class StudyTiming {
  const StudyTiming({
    this.armDelay = const Duration(milliseconds: 1100),
    this.holdDuration = const Duration(milliseconds: 450),
  });

  final Duration armDelay;
  final Duration holdDuration;

  static const participant = StudyTiming();

  static const instant = StudyTiming(
    armDelay: Duration.zero,
    holdDuration: Duration.zero,
  );
}

class StudyScope extends InheritedNotifier<StudyController> {
  const StudyScope({
    super.key,
    required StudyController controller,
    required this.timing,
    required super.child,
  }) : super(notifier: controller);

  final StudyTiming timing;

  StudyController get controller => notifier!;

  static StudyScope watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<StudyScope>();
    assert(scope != null, 'StudyScope is missing above this widget');
    return scope!;
  }
}
