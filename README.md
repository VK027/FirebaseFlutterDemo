# ffd

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Firebase Authentication

Facebook Sign In for [Firebase UI Auth](https://pub.dev/packages/firebase_ui_auth)

## Installation

Add dependencies

```sh
flutter pub add firebase_ui_auth
flutter pub add firebase_ui_oauth_facebook
flutter pub global activate flutterfire_cli
flutterfire configure
```
Enable Facebook provider on [firebase console](https://console.firebase.google.com/).



```sh
dart pub global activate flutterfire_cli  
export PATH="$PATH":"$HOME/.pub-cache/bin"
curl -sL https://firebase.tools | bash  
firebase login
flutterfire configure
```