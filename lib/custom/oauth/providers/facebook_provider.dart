import 'package:desktop_webview_auth/desktop_webview_auth.dart' show AuthResult, ProviderArgs;
import 'package:desktop_webview_auth/facebook.dart';
import 'package:firebase_auth/firebase_auth.dart' hide OAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../themes/fb_theme.dart';
import 'oauth_provider.dart';

class FacebookProvider extends OAuthProvider {
  @override
  final providerId = 'facebook.com';

  FacebookAuth provider = FacebookAuth.instance;
  final String clientId;
  final String? redirectUri;

  @override
  final style = const FacebookProviderButtonStyle();

  @override
  late final ProviderArgs desktopSignInArgs = FacebookSignInArgs(
    clientId: clientId,
    redirectUri: redirectUri ?? defaultRedirectUri,
  );

  FacebookProvider({
    required this.clientId,
    this.redirectUri,
  });

  void _handleResult(LoginResult result, AuthAction action) {
    switch (result.status) {
      case LoginStatus.success:
        final token = result.accessToken!.token;
        final credential = FacebookAuthProvider.credential(token);

        onCredentialReceived(credential, action);
        break;
      case LoginStatus.cancelled:
        authListener.onError(AuthCancelledException());
        break;
      case LoginStatus.failed:
        authListener.onError(Exception(result.message));
        break;
      case LoginStatus.operationInProgress:
        authListener.onError(
          Exception('Previous login request is not complete'),
        );
    }
  }

  @override
  OAuthCredential fromDesktopAuthResult(AuthResult result) {
    return FacebookAuthProvider.credential(result.accessToken!);
  }

  @override
  FacebookAuthProvider get firebaseAuthProvider => FacebookAuthProvider();

  @override
  Future<void> logOutProvider() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await provider.logOut();
    }
  }

  @override
  void mobileSignIn(AuthAction action) {
    final result = provider.login();
    result
        .then((result) => _handleResult(result, action))
        .catchError(authListener.onError);
  }

  @override
  bool supportsPlatform(TargetPlatform platform) {
    return true;
  }
}