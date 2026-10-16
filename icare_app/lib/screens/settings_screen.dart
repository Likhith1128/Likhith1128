import 'package:flutter/material.dart';

import '../models.dart';
import '../study_scope.dart';
import '../theme.dart';
import '../widgets/hold_button.dart';
import '../widgets/study_scaffold.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _name;
  late final TextEditingController _goal;
  var _fieldsReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_fieldsReady) return;
    final controller = StudyScope.watch(context).controller;
    _name = TextEditingController(text: controller.name);
    _goal = TextEditingController(text: controller.exerciseGoal);
    _fieldsReady = true;
  }

  @override
  void dispose() {
    _name.dispose();
    _goal.dispose();
    super.dispose();
  }

  Future<void> _pickTime({
    required int current,
    required ValueChanged<int> onSelected,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked == null) return;
    onSelected((picked.hour * 60) + picked.minute);
  }

  @override
  Widget build(BuildContext context) {
    final controller = StudyScope.watch(context).controller;
    final theme = Theme.of(context);

    return StudyScaffold(
      title: 'Settings',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Font size', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 12),
            for (final choice in FontChoice.values) ...[
              HoldButton(
                key: Key('font-${choice.name}'),
                label: choice.label,
                icon: controller.fontChoice == choice
                    ? Icons.check_circle
                    : Icons.text_fields,
                style: controller.fontChoice == choice
                    ? HoldStyle.primary
                    : HoldStyle.secondary,
                onPressed: () => controller.setFont(choice),
              ),
            ],
            const SizedBox(height: 8),
            Text('Your name', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 12),
            TextField(
              key: const Key('name-field'),
              controller: _name,
              textCapitalization: TextCapitalization.words,
              style: theme.textTheme.bodyLarge,
              decoration: const InputDecoration(hintText: 'Enter your name'),
              onChanged: controller.setName,
            ),
            const SizedBox(height: 24),
            Text('Assigned group', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text(
              'Set by the study team.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: StudyColors.muted,
              ),
            ),
            const SizedBox(height: 12),
            for (final group in StudyGroup.values) ...[
              HoldButton(
                key: Key('group-${group.name}'),
                label: group.label,
                icon: controller.group == group
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                style: controller.group == group
                    ? HoldStyle.primary
                    : HoldStyle.secondary,
                onPressed: () => controller.setGroup(group),
              ),
            ],
            Text('Important exercise goal', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text(
              'Used in the exercise-goals messages.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: StudyColors.muted,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('goal-field'),
              controller: _goal,
              textCapitalization: TextCapitalization.sentences,
              style: theme.textTheme.bodyLarge,
              decoration: const InputDecoration(hintText: 'good health'),
              onChanged: controller.setExerciseGoal,
            ),
            const SizedBox(height: 24),
            Text('Morning prompt time', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 12),
            HoldButton(
              key: const Key('morning-time'),
              label: formatClock(controller.morningMinutes),
              icon: Icons.schedule,
              style: HoldStyle.secondary,
              onPressed: () => _pickTime(
                current: controller.morningMinutes,
                onSelected: controller.setMorningMinutes,
              ),
            ),
            Text('Bedtime', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 12),
            HoldButton(
              key: const Key('bedtime'),
              label: formatClock(controller.bedMinutes),
              icon: Icons.bedtime_outlined,
              style: HoldStyle.secondary,
              onPressed: () => _pickTime(
                current: controller.bedMinutes,
                onSelected: controller.setBedMinutes,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
