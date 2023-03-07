import  'package:desktop_webview_auth/desktop_webview_auth.dart' show AuthResult;
import 'package:desktop_webview_auth/twitter.dart';

import 'package:firebase_auth/firebase_auth.dart' hide OAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:twitter_login/twitter_login.dart';

import '../themes/twitter_theme.dart';
import 'oauth_provider.dart';

class TwitterProvider extends OAuthProvider {
  @override
  final providerId = 'twitter.com';
  final String apiKey;
  final String apiSecretKey;
  final String? redirectUri;

  @override
  final style = const TwitterProviderButtonStyle();

  @override
  late final desktopSignInArgs = TwitterSignInArgs(
    apiKey: apiKey,
    apiSecretKey: apiSecretKey,
    redirectUri: redirectUri ?? defaultRedirectUri,
  );

  late TwitterLogin provider = TwitterLogin(
    apiKey: apiKey,
    apiSecretKey: apiSecretKey,
    redirectURI: redirectUri ?? defaultRedirectUri,
  );

  TwitterProvider({
    required this.apiKey,
    required this.apiSecretKey,
    this.redirectUri,
  });

  @override
  void mobileSignIn(AuthAction action) {
    final result = provider.login();

    result.then((value) {
      switch (value.status!) {
        case TwitterLoginStatus.loggedIn:
          final credential = TwitterAuthProvider.credential(
            accessToken: value.authToken!,
            secret: value.authTokenSecret!,
          );

          onCredentialReceived(credential, action);
          break;
        case TwitterLoginStatus.cancelledByUser:
          authListener.onError(AuthCancelledException());
          break;
        case TwitterLoginStatus.error:
          authListener.onError(Exception(value.errorMessage));
          break;
      }
    }).catchError((Object err) {
      authListener.onError(err);
    });
  }

  @override
  OAuthCredential fromDesktopAuthResult(AuthResult result) {
    return TwitterAuthProvider.credential(
      accessToken: result.accessToken!,
      secret: result.tokenSecret!,
    );
  }

  @override
  TwitterAuthProvider get firebaseAuthProvider => TwitterAuthProvider();

  @override
  Future<void> logOutProvider() {
    return SynchronousFuture(null);
  }

  @override
  bool supportsPlatform(TargetPlatform platform) {
    return true;
  }
}