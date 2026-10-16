import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icare_app/app.dart';
import 'package:icare_app/models.dart';
import 'package:icare_app/prompts.dart';
import 'package:icare_app/study_controller.dart';
import 'package:icare_app/study_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<StudyController> startApp(
  WidgetTester tester, {
  bool welcomed = false,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 844);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  SharedPreferences.setMockInitialValues(
    welcomed ? {StudyController.storageKey: '{"welcomed":true}'} : {},
  );
  final preferences = await SharedPreferences.getInstance();
  final controller = StudyController(preferences);
  await tester.pumpWidget(
    ICareApp(controller: controller, timing: StudyTiming.instant),
  );
  await tester.pumpAndSettle();
  return controller;
}

Future<void> holdTap(WidgetTester tester, Finder finder) async {
  final scrollable = find.ancestor(
    of: finder,
    matching: find.byType(Scrollable),
  );
  if (scrollable.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(finder, 200, scrollable: scrollable.first);
  }
  await tester.tap(finder);
  await tester.pump();
}

void main() {
  testWidgets('welcome explains the study and opens home', (tester) async {
    await startApp(tester);

    expect(find.text(welcomeMessage), findsOneWidget);
    expect(find.text('Welcome to the study'), findsOneWidget);

    await holdTap(tester, find.byKey(const Key('welcome-continue')));
    await tester.pumpAndSettle();

    expect(find.text('Jane Smith'), findsOneWidget);
    expect(find.text('Begin'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.textContaining('Morning'), findsWidgets);
    expect(find.textContaining('Evening'), findsWidgets);

    final begin = tester.getRect(find.byKey(const Key('home-begin')));
    expect(begin.left, greaterThanOrEqualTo(24));
    expect(begin.right, lessThanOrEqualTo(390 - 24));
    expect(begin.height, greaterThanOrEqualTo(72));
  });

  testWidgets('each study group shows its own morning prompt', (tester) async {
    final controller = await startApp(tester, welcomed: true);

    Future<void> expectMorning(StudyGroup group, String snippet) async {
      controller.setGroup(group);
      await holdTap(tester, find.byKey(const Key('home-morning')));
      await tester.pumpAndSettle();
      expect(find.textContaining(snippet), findsOneWidget);
      await holdTap(tester, find.byKey(const Key('prompt-got-it')));
      await tester.pumpAndSettle();
      expect(find.text('Morning message opened today'), findsOneWidget);
    }

    await expectMorning(StudyGroup.exerciseGoals, 'good health');
    await expectMorning(
      StudyGroup.awareness,
      'positive feelings during the physical activity',
    );
    await expectMorning(StudyGroup.distraction, 'enjoyable topic');
  });

  testWidgets('activity flow records the bout and the group question', (
    tester,
  ) async {
    final controller = await startApp(tester, welcomed: true);

    await holdTap(tester, find.byKey(const Key('home-begin')));
    await tester.pumpAndSettle();
    expect(find.text('Are you beginning physical activity?'), findsOneWidget);

    await holdTap(tester, find.byKey(const Key('begin-yes')));
    await tester.pumpAndSettle();
    expect(find.text(watchCue), findsOneWidget);
    expect(find.textContaining('good health'), findsOneWidget);

    await holdTap(tester, find.byKey(const Key('during-got-it')));
    await tester.pump();
    expect(find.text('End'), findsOneWidget);
    expect(find.byKey(const Key('elapsed-time')), findsOneWidget);

    await holdTap(tester, find.byKey(const Key('end-bout')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Would you like to end your exercise?'), findsOneWidget);

    await holdTap(tester, find.byKey(const Key('end-yes')));
    await tester.pumpAndSettle();
    expect(find.text(activityQuestion), findsOneWidget);
    expect(
      find.textContaining('think about your exercise goal'),
      findsOneWidget,
    );

    await holdTap(tester, find.byKey(const Key('activity-other')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('other-detail')), findsOneWidget);

    await holdTap(tester, find.byKey(const Key('activity-running')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('other-detail')), findsNothing);

    await holdTap(tester, find.byKey(const Key('rating-often')));
    await tester.pumpAndSettle();
    await holdTap(tester, find.byKey(const Key('save-report')));
    await tester.pumpAndSettle();

    expect(find.text('Jane Smith'), findsOneWidget);
    expect(controller.completedToday, hasLength(1));
    expect(controller.completedToday.single.activity, ActivityKind.running);
    expect(controller.completedToday.single.rating, Frequency.often);
    expect(controller.completedToday.single.reportComplete, isTrue);
  });

  testWidgets('evening report asks for count and duration', (tester) async {
    final controller = await startApp(tester, welcomed: true);

    await holdTap(tester, find.byKey(const Key('home-evening')));
    await tester.pumpAndSettle();
    expect(find.text(eveningCountQuestion), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    await holdTap(tester, find.byKey(const Key('count-plus')));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('30 min'), findsOneWidget);

    await holdTap(tester, find.byKey(const Key('minutes-plus-0')));
    await tester.pumpAndSettle();
    expect(find.text('35 min'), findsOneWidget);

    await holdTap(tester, find.byKey(const Key('save-evening')));
    await tester.pumpAndSettle();
    expect(find.text('Evening report saved'), findsOneWidget);
    expect(controller.todayReport?.count, 1);
    expect(controller.todayReport?.minutes, [35]);
  });

  testWidgets('font size setting scales text and is remembered', (
    tester,
  ) async {
    await startApp(tester, welcomed: true);

    await holdTap(tester, find.byKey(const Key('home-settings')));
    await tester.pumpAndSettle();
    await holdTap(tester, find.byKey(const Key('font-extraLarge')));
    await tester.pumpAndSettle();

    final scale = MediaQuery.textScalerOf(
      tester.element(find.text('Font size')),
    ).scale(1);
    expect(scale, closeTo(1.35, 0.01));

    final restored = StudyController(await SharedPreferences.getInstance());
    expect(restored.fontChoice, FontChoice.extraLarge);
    expect(restored.welcomed, isTrue);
  });

  testWidgets('home leaves a prompt without marking it read', (tester) async {
    final controller = await startApp(tester, welcomed: true);

    await holdTap(tester, find.byKey(const Key('home-morning')));
    await tester.pumpAndSettle();
    await holdTap(tester, find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Morning message not opened yet'), findsOneWidget);
    expect(controller.morningSeenToday, isFalse);
  });
}
