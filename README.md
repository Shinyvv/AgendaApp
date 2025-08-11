# app_prueba

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# SaaS Appointments MVP

This project scaffolds a Flutter + Firebase multi-tenant appointment management MVP.

Key pieces added:
- Firebase initialization, go_router, login with email/password and Google.
- Role-based splash redirect using Firebase Auth custom claims (admin/employee/client).
- Firestore security rules for multi-tenancy and roles in `firestore.rules`.
- Appointment repository with transaction-based per-slot locks.
- Local notifications helper.
- Cloud Functions (TypeScript) for email (Resend) and metrics aggregation.
- `vercel.json` for SPA deployment of Flutter Web.

Next steps:
1. Configure Firebase for the app (FlutterFire) and add `firebase_options.dart` or call `Firebase.initializeApp(options: ...)`.
2. Deploy Firestore rules: `firebase deploy --only firestore:rules`.
3. Setup Cloud Functions: in `functions/` run `npm i` then `npm run build` and deploy.
4. Add UI for booking calendar and admin dashboard.
5. Build for web and deploy to Vercel from `build/web`.
