# I-CARE

Phone frontend for the I-CARE physical-activity prompting study. The same Flutter project runs on Android, iOS, and the web.

The screens are built for middle-aged and older adults: large type in Atkinson Hyperlegible, a font-size setting, space between controls, controls inset from the screen edge, and a labeled Home or Back control. Buttons respond to a single tap.

The app opens with sign-up and sign-in forms. Authentication is currently a local UI demo: it validates form entries but does not verify sign-in credentials with a server, and passwords are not saved. Connect an authentication provider before using it to protect real accounts.

## Study groups

Settings stores the assigned group:

- Exercise goals
- Awareness
- Distraction

Morning, during-activity, and after-activity messages follow that group. Exercise-goals messages use the goal phrase from Settings. The default phrase is "good health".

## What you can do in the app

- Read the welcome message.
- Open the morning prompt and mark it seen.
- Begin a bout, confirm it, read the during-activity prompt, and watch the timer.
- End the bout and answer the activity and frequency questions. Choosing Other opens a text field.
- Complete the evening report: how many times you exercised, and how long each bout was.
- Review today's completed activities in Activity history.
- View a simulated heart rate in beats per minute (BPM) during an active bout; live watch readings are not connected yet.

Answers stay on the device. A watch or heart-rate trigger can later open the same morning, begin, and end screens.

## Run

```bash
cd icare_app
flutter pub get
flutter run
```

Web preview:

```bash
flutter run -d chrome
```
