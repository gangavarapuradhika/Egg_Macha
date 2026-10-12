# Egg Macha Flutter Frontend

A responsive Flutter frontend for Egg Macha with user login/create-account screens, a hidden mobile admin entry point, menu/cart quantity controls, order summary, order history, and order-tracking UI.

## Run the app
```bash
flutter clean
flutter pub get
flutter analyze
flutter run
```

Run in Chrome:
```bash
flutter run -d chrome
```

Run on an Android phone:
```bash
flutter devices
flutter run
```

## App flows
- Main page: tap **USER LOGIN** to open user login.
- Create account: open from the User Login page.
- Admin on mobile: long-press the **EGG MACHA** logo on the main page.
- Menu: add/remove quantities; cart and order summary show quantities and line totals.
- Orders: starts empty. After placing an order, its items and quantities appear in My Orders and Order Tracking.
- Admin order list: starts empty and shows orders created in this app session.

## Backend/database integration notes
This is intentionally a frontend preview. Login and account creation currently validate form input only; they do not create secure accounts or authenticate against a server. Orders are stored in memory only and are cleared when the app restarts. Connect these flows to your backend/database later for persistent users, order records, payments, and live tracking updates.

No sample customer names or historical orders are preloaded.

## Admin demo login
Long-press the EGG MACHA logo on the landing page, then use:
- Email: `admin@eggmacha.com`
- Password: `admin123`

These are frontend demo credentials only. Replace with server-side authentication before real deployment.

## Macha Special
The Home page now includes a signature Macha Special food card connected to the shared cart. Its quantity controls, cart total, checkout, order list, and tracking snapshot use the same shared cart state as other menu items.

## Reusable UI components
- `lib/reusable_buttons.dart`: `AppButton`, `BackButtonApp`, and `CategoryButton`.
- `lib/reusable_cards.dart`: `AppCard` and `MetricCard`.
- Business management operation tiles use the shared `AppCard`; the staff close-day action uses the shared `AppButton`.
- See `REUSABLE_BUTTONS_GUIDE.txt` for examples.

These are frontend-only demo screens. Do not use demo login or in-memory entries as real security or permanent storage.
