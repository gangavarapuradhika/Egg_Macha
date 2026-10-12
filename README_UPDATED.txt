EGG MACHA FLUTTER FRONTEND — CLEANED PROJECT

This is a frontend-only Flutter app. Saved delivery addresses are stored locally on the device with SharedPreferences. This is not a server/database and does not sync between devices.

Included areas: customer landing/login, menu, cart/order flow, saved address management, order/profile screens, admin screens, staff screens, reusable buttons/cards, and image assets.

IMPORTANT VALIDATION NOTE
The supplied archive contained Flutter-generated cache/build folders and an outdated counter widget test. Those caches were removed from this delivery and the test was updated to a landing-screen smoke test. The source was reviewed and the address store was updated to persist saved addresses locally. This environment does not have the Flutter SDK installed, so a real `flutter analyze`, `flutter test`, or Android APK build could not be run here. Please run the verification commands below in VS Code on your computer before release.

VERIFY IN VS CODE TERMINAL (open the folder containing pubspec.yaml):
1. flutter pub get
2. dart format lib test
3. flutter analyze
4. flutter test
5. flutter build apk --release

APK output after a successful build:
build/app/outputs/flutter-apk/app-release.apk

The Android SDK must be installed and configured for APK building. The `android/local.properties` machine-specific file is intentionally not included; Flutter can recreate it when Android SDK is configured.

Reusable UI files:
- lib/reusable_buttons.dart: AppButton, BackButtonApp, CategoryButton
- lib/reusable_cards.dart: AppCard, MetricCard
- lib/widgets.dart: shared brand, primary/outline buttons, food/special cards and common UI

Data note: customer accounts, admin/staff authentication, cart/orders and order status are frontend/demo state unless connected to a backend. Address storage is local to this app installation. Do not use demo authentication for a production launch.
