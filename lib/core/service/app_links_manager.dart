import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/auth/presentation/screens/reset_password_screen.dart';
import 'package:quiz_app/core/functions/functions.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppLinksManager {
  final AppLinks _appLinks = AppLinks();
  bool _hasHandledInitialLink = false;

  static final AppLinksManager _instance = AppLinksManager._internal();

  factory AppLinksManager() => _instance;

  AppLinksManager._internal();

  Future<void> initAppLinks() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null && !_hasHandledInitialLink) {
        _handleAppLink(uri);
        _hasHandledInitialLink = true;
      }
    } catch (e) {
      debugPrint('Error getting initial app links: $e');
    }

    _appLinks.uriLinkStream.listen(
      (uri) {
        _handleAppLink(uri);
      },
    );
  }

  void _handleAppLink(Uri uri) {
    if (uri.path == '/api/Account/reset-password') {
      final token = uri.queryParameters['token'];
      final email = uri.queryParameters['email'];

      if (token != null &&
          email != null &&
          token.isNotEmpty &&
          email.isNotEmpty) {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(
              token: token,
              email: email,
            ),
          ),
        );
      }
    } else {
      final pathSegments = uri.pathSegments;
      if (pathSegments.length >= 2 && pathSegments[0] == 'reset-password') {
        final pathToken = pathSegments[1];

        Navigator.of(navigatorKey.currentState!.context).push(
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(
                token: pathToken, email: uri.queryParameters['email']),
          ),
        );
      } else {
        Functions.showSnackBar(
          navigatorKey.currentState!.context,
          title: 'Error',
          content: 'Invalid link',
          icon: Icons.error_outline,
          color: Colors.red,
        );
      }
    }
  }
}
