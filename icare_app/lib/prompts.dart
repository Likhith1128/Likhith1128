import 'models.dart';

String morningPrompt(StudyGroup group, String goal) {
  switch (group) {
    case StudyGroup.distraction:
      return 'Good morning! When engaging in physical activity, think about an '
          'enjoyable topic that is most important to you. Next time you engage '
          'in physical activity, log into the app and rate how much you were '
          'thinking about topics other than your exercise experience during '
          'the physical activity.';
    case StudyGroup.awareness:
      return 'Good morning! When engaging in physical activity, bring awareness '
          'to the positive feelings during and after your bout of physical '
          'activity without judgment. Next time you engage in physical '
          'activity, log into the app and rate how much you were aware of '
          'your positive feelings during the physical activity.';
    case StudyGroup.exerciseGoals:
      return 'Good morning! You mentioned that one of your important exercise '
          'goals is $goal. When engaging in physical activity, think about '
          'this goal and why it is important to you. Next time you engage in '
          'physical activity, log into the app and rate how much you are '
          'thinking about exercise goals.';
  }
}

String duringPrompt(StudyGroup group, String goal) {
  switch (group) {
    case StudyGroup.awareness:
      return 'Bring awareness to the positive feelings during and after your '
          'bout of physical activity without judgment.';
    case StudyGroup.exerciseGoals:
      return 'You mentioned that one of your important exercise goals is '
          '$goal. Think about this goal and why it is important to you.';
    case StudyGroup.distraction:
      return 'Think about something enjoyable other than exercise.';
  }
}

String afterQuestion(StudyGroup group) {
  switch (group) {
    case StudyGroup.exerciseGoals:
      return 'How often did you think about your exercise goal while engaging '
          'in physical activity?';
    case StudyGroup.awareness:
      return 'How often were you aware of your positive feelings during and '
          'after the physical activity?';
    case StudyGroup.distraction:
      return 'How often were you thinking about something else other than '
          'your exercise experience?';
  }
}

const activityQuestion = 'What kind of physical activity did you do?';

const eveningCountQuestion = 'How many times did you exercise today?';

const welcomeMessage =
    'Hello! Thank you for choosing to participate in this study. The goal of '
    'the study is to examine whether brief messages can influence how people '
    'think and feel during physical activity.';

const seenInstruction = 'Click the check mark so we know you saw this!';

const watchCue = 'Take a look at your phone!';
