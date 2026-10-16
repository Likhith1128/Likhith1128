import 'package:flutter/material.dart';

import '../models.dart';
import '../navigation.dart';
import '../prompts.dart';
import '../study_scope.dart';
import '../widgets/hold_button.dart';
import '../widgets/study_scaffold.dart';

class PostActivityScreen extends StatefulWidget {
  const PostActivityScreen({super.key});

  @override
  State<PostActivityScreen> createState() => _PostActivityScreenState();
}

class _PostActivityScreenState extends State<PostActivityScreen> {
  ActivityKind? _activity;
  Frequency? _rating;
  final _other = TextEditingController();

  @override
  void dispose() {
    _other.dispose();
    super.dispose();
  }

  bool get _valid {
    if (_activity == null || _rating == null) return false;
    if (_activity == ActivityKind.other && _other.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final controller = StudyScope.watch(context).controller;
    final theme = Theme.of(context);
    final question = afterQuestion(controller.group);

    return StudyScaffold(
      title: 'After activity',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(activityQuestion, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 12),
                  for (final kind in ActivityKind.values) ...[
                    HoldButton(
                      key: Key('activity-${kind.name}'),
                      label: kind.label,
                      icon: _activity == kind
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      style: _activity == kind
                          ? HoldStyle.primary
                          : HoldStyle.secondary,
                      onPressed: () => setState(() => _activity = kind),
                    ),
                  ],
                  if (_activity == ActivityKind.other) ...[
                    TextField(
                      key: const Key('other-detail'),
                      controller: _other,
                      textCapitalization: TextCapitalization.sentences,
                      style: theme.textTheme.bodyLarge,
                      decoration: const InputDecoration(
                        labelText: 'Other activity',
                        hintText: 'Type the activity',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const SizedBox(height: 8),
                  Text(question, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 12),
                  for (final rating in Frequency.values) ...[
                    HoldButton(
                      key: Key('rating-${rating.name}'),
                      label: rating.label,
                      icon: _rating == rating
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      style: _rating == rating
                          ? HoldStyle.primary
                          : HoldStyle.secondary,
                      onPressed: () => setState(() => _rating = rating),
                    ),
                  ],
                ],
              ),
            ),
          ),
          HoldButton(
            key: const Key('save-report'),
            label: 'Save',
            icon: Icons.check,
            onPressed: _valid
                ? () {
                    controller.saveActivityReport(
                      activity: _activity!,
                      otherDetail: _other.text,
                      rating: _rating!,
                    );
                    openHome(context);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
