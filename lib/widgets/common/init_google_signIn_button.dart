import 'dart:html' as html;
import 'dart:js' as js;
import 'package:edustore/models/user_model.dart';

// ⚠️ À importer uniquement si tu build pour le web
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;

typedef OnReceivedJwt = Future<void> Function(String jwt, UserRole role);

void initGoogleSignInButton({required OnReceivedJwt onReceivedJwt}) {
  // ✅ NE PAS appeler setUrlStrategy ici ! Cela doit être fait UNE seule fois dans main.dart

  // ✅ Enregistrement du bouton Google Sign-In natif web
  ui_web.platformViewRegistry.registerViewFactory(
    'google-sign-in-button',
    (int viewId) {
      final div = html.DivElement()
        ..id = 'g_id_signin'
        ..style.width = '240px'
        ..style.height = '50px'
        ..setAttribute('data-type', 'standard')
        ..setAttribute('data-theme', 'outline')
        ..setAttribute('data-text', 'sign_in_with')
        ..setAttribute('data-size', 'large')
        ..setAttribute('data-logo_alignment', 'left')
        ..setAttribute('data-client_id',
            '537420744442-vejb0dp6t1p6q9rk0b2vpregjnjshkcn.apps.googleusercontent.com')
        ..setAttribute('data-callback', 'handleCredentialResponse');
      return div;
    },
  );

  // ✅ Liaison JS → Dart
  js.context['handleCredentialResponse'] = (dynamic response) async {
    final credential = response['credential'];
    if (credential != null) {
      print("✅ JWT reçu via Google Sign-In : $credential");

      // 🟡 À adapter selon ton rôle courant (ou stocker dans une variable globale)
      const role = UserRole.student; // ou UserRole.teacher selon le contexte

      await onReceivedJwt(credential, role);
    }
  };
}
