# realtime_todo_mvvm
# Realtime TODO (Flutter, MVVM, Riverpod)

MVVM Flutter TODO app with:
- Riverpod state management
- Realtime collaboration using Firebase Cloud Firestore
- Share list via email or system share sheet
- Infinite list-ready structure
- Responsive UI (mobile/tablet/desktop)

## Project Structure
```
lib/
  src/
    models/
    repositories/
    services/
    providers/
    viewmodels/
    views/
    widgets/
    routing/
    utils/
```

## Dependencies
- flutter_riverpod, riverpod_annotation, riverpod_generator
- firebase_core, cloud_firestore, firebase_auth
- share_plus, url_launcher, responsive_framework

## Firebase Setup
1. Create a Firebase project.
2. Enable Authentication (Anonymous sign-in or Email/Password).
3. Enable Cloud Firestore.
4. Add apps (iOS, Android, Web, macOS if needed) and download configs:
   - Android: place `android/app/google-services.json`.
   - iOS/macOS: place `ios/Runner/GoogleService-Info.plist` and `macos/Runner/GoogleService-Info.plist`.
   - Web: run `flutterfire configure` or manually set default options in `web/index.html` if using Web.
5. Add Firestore Rules (minimal demo):
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /lists/{listId} {
      allow read, write: if request.auth != null;
      match /todos/{todoId} {
        allow read, write: if request.auth != null;
      }
    }
  }
}
```

## Run
```
flutter pub get
flutter run
```

## Usage
- On launch, tap "Continue Anonymously" to sign in.
- A default list is opened using your `uid` as list id.
- Add tasks with the input field.
- Toggle completion via checkbox.
- Share the list id via system share or invite with email (mailto link).
- To truly share editing, grant access in Firestore rules based on email/uid mapping in production.

## Infinite List
The ViewModel and repository are structured for paging. Hook a DocumentSnapshot cursor to `fetchNext` and call `loadMore` on scroll end.

## GitHub
This directory is already a git repo. To push to a new GitHub repo:
```
cd realtime_todo_mvvm
git remote add origin https://github.com/<your-username>/realtime_todo_mvvm.git
git branch -M main
git push -u origin main
```

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
