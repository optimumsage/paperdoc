import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class GoogleTokens {
  const GoogleTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiry,
  });

  final String accessToken;
  final String? refreshToken;
  final DateTime expiry;
}

/// Bring-your-own-credentials Google OAuth using the installed-app loopback +
/// PKCE flow. Works on desktop and Android: a local HTTP server on
/// 127.0.0.1 catches the redirect. The user supplies the client id/secret from
/// their own "Desktop app" OAuth client.
class GoogleOAuth {
  static const authEndpoint =
      'https://accounts.google.com/o/oauth2/v2/auth';
  static const tokenEndpoint = 'https://oauth2.googleapis.com/token';

  /// Per-file Drive scope — access limited to files this app creates.
  static const scope = 'https://www.googleapis.com/auth/drive.file';

  /// Runs the interactive sign-in and returns tokens (incl. a refresh token).
  Future<GoogleTokens> signIn({
    required String clientId,
    required String clientSecret,
  }) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final redirectUri = 'http://127.0.0.1:${server.port}';
    final verifier = _randomUrlToken(64);
    final state = _randomUrlToken(16);

    final authUrl = Uri.parse(authEndpoint).replace(queryParameters: {
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'response_type': 'code',
      'scope': scope,
      'code_challenge': pkceChallenge(verifier),
      'code_challenge_method': 'S256',
      'access_type': 'offline',
      'prompt': 'consent',
      'state': state,
    });

    try {
      if (!await launchUrl(authUrl, mode: LaunchMode.externalApplication)) {
        throw const GoogleOAuthException('Could not open the browser.');
      }

      final code = await _awaitRedirect(server, expectedState: state);
      final response = await _postWithRetry(
        Uri.parse(tokenEndpoint),
        {
          'client_id': clientId,
          'client_secret': clientSecret,
          'code': code,
          'code_verifier': verifier,
          'grant_type': 'authorization_code',
          'redirect_uri': redirectUri,
        },
      );
      if (response.statusCode != 200) {
        throw GoogleOAuthException('Token exchange failed: ${response.body}');
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return GoogleTokens(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String?,
        expiry: DateTime.now()
            .add(Duration(seconds: json['expires_in'] as int)),
      );
    } finally {
      await server.close(force: true);
    }
  }

  /// Exchanges a refresh token for a fresh access token.
  Future<GoogleTokens> refresh({
    required String clientId,
    required String clientSecret,
    required String refreshToken,
  }) async {
    final response = await _postWithRetry(
      Uri.parse(tokenEndpoint),
      {
        'client_id': clientId,
        'client_secret': clientSecret,
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
      },
    );
    if (response.statusCode != 200) {
      throw GoogleOAuthException('Token refresh failed: ${response.body}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return GoogleTokens(
      accessToken: json['access_token'] as String,
      refreshToken: refreshToken,
      expiry:
          DateTime.now().add(Duration(seconds: json['expires_in'] as int)),
    );
  }

  Future<String> _awaitRedirect(
    HttpServer server, {
    required String expectedState,
  }) async {
    await for (final request in server) {
      final params = request.uri.queryParameters;
      final code = params['code'];
      final error = params['error'];
      if (code == null && error == null) {
        // Ignore noise (e.g. favicon requests).
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        continue;
      }
      request.response.headers.contentType = ContentType.html;
      request.response.write(
        '<html><body style="font-family:sans-serif">'
        '<h2>PaperDoc is connected.</h2>'
        '<p>You can close this tab and return to the app.</p>'
        '</body></html>',
      );
      await request.response.close();

      if (error != null) {
        throw GoogleOAuthException('Authorization denied: $error');
      }
      if (params['state'] != expectedState) {
        throw const GoogleOAuthException('State mismatch — aborting.');
      }
      return code!;
    }
    throw const GoogleOAuthException('No redirect received.');
  }

  /// POSTs with a few retries to survive transient DNS/socket failures that are
  /// common on mobile right after the radio wakes (e.g. the loopback OAuth
  /// redirect succeeds, then the first real network call fails host lookup).
  Future<http.Response> _postWithRetry(Uri url, Map<String, String> body) async {
    Object? lastError;
    for (var attempt = 0; attempt < 4; attempt++) {
      try {
        return await http
            .post(url, body: body)
            .timeout(const Duration(seconds: 20));
      } on SocketException catch (e) {
        lastError = e;
      } on http.ClientException catch (e) {
        lastError = e;
      } on TimeoutException catch (e) {
        lastError = e;
      }
      await Future<void>.delayed(Duration(milliseconds: 600 * (attempt + 1)));
    }
    throw GoogleOAuthException(
        'Network error reaching Google (check your connection): $lastError');
  }

  static String pkceChallenge(String verifier) {
    final digest = sha256.convert(ascii.encode(verifier));
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  static String _randomUrlToken(int bytes) {
    final rng = Random.secure();
    final values = List<int>.generate(bytes, (_) => rng.nextInt(256));
    return base64UrlEncode(values).replaceAll('=', '');
  }
}

class GoogleOAuthException implements Exception {
  const GoogleOAuthException(this.message);
  final String message;
  @override
  String toString() => 'GoogleOAuthException: $message';
}
