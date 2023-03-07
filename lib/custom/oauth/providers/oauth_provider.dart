
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';

import '../oauth_sign_in.dart' if (dart.library.html) '../oauth_sign_in_web.dart';
import '../themes/oauth_theme.dart';

/// A listener of the [OAuthProvider].
/// See also:
///  * [OAuthFlow]
abstract class OAuthListener extends AuthListener {}

/// {@template ui.oauth.oauth_provider}
/// An [AuthProvider] that allows to authenticate using OAuth.
/// {@endtemplate}
abstract class OAuthProvider
    extends AuthProvider<OAuthListener, OAuthCredential>
    with PlatformSignInMixin {
  @override
  late OAuthListener authListener;

  /// {@macro ui.oauth.themed_oauth_provider_button_style}
  ThemedOAuthProviderButtonStyle get style;

  String get defaultRedirectUri => 'https://${auth.app.options.projectId}.firebaseapp.com/__/auth/handler';

  void signIn(TargetPlatform platform, AuthAction action) {
    authListener.onBeforeSignIn();
    platformSignIn(platform, action);
  }

  @override
  void platformSignIn(TargetPlatform platform, AuthAction action);

  Future<void> logOutProvider();
}