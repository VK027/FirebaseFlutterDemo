import 'package:desktop_webview_auth/desktop_webview_auth.dart' show AuthResult, ProviderArgs;
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';

import '../themes/apple_theme.dart';
import 'oauth_provider.dart';

class AppleProvider extends OAuthProvider {
  @override
  final providerId = 'apple.com';

  @override
  final style = const AppleProviderButtonStyle();

  /// {@template ui.auth.oauth.apple_provider.scopes}
  /// The scopes that will be passed down to the [fba.AppleAuthProvider].
  /// {@endtemplate}
  final Set<String> scopes;

  @override
  fba.AppleAuthProvider firebaseAuthProvider = fba.AppleAuthProvider();

  AppleProvider({
    /// {@macro ui.auth.oauth.apple_provider.scopes}
    this.scopes = const <String>{'email'},
  }) {
    scopes.forEach(firebaseAuthProvider.addScope);
  }

  @override
  void mobileSignIn(AuthAction action) {
    authListener.onBeforeSignIn();

    auth.signInWithProvider(firebaseAuthProvider).then((userCred) {
      if (action == AuthAction.signIn) {
        authListener.onSignedIn(userCred);
      } else {
        authListener.onCredentialLinked(userCred.credential!);
      }
    }).catchError((Object err) {
      authListener.onError(err);
    });
  }

  @override
  void desktopSignIn(AuthAction action) {
    mobileSignIn(action);
  }

  @override
  ProviderArgs get desktopSignInArgs => throw UnimplementedError();

  @override
  fba.OAuthCredential fromDesktopAuthResult(AuthResult result) {
    throw UnimplementedError();
  }

  @override
  Future<void> logOutProvider() {
    return SynchronousFuture(null);
  }

  @override
  bool supportsPlatform(TargetPlatform platform) {
    return kIsWeb ||
        platform == TargetPlatform.iOS ||
        platform == TargetPlatform.macOS;
  }
}