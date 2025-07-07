import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edustore/providers/auth_provider.dart';
import 'package:edustore/models/user_model.dart';
import 'package:edustore/screens/dashboard/teacher_dashboard_screen.dart';
import 'package:edustore/screens/dashboard/student_dashboard_screen.dart';
import 'package:edustore/widgets/common/init_google_signIn_button.dart';
// important pour `registerViewFactory`

class LoginScreen extends StatefulWidget {
  final UserRole userRole;

  const LoginScreen({super.key, required this.userRole});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      initGoogleSignInButton(
        onReceivedJwt: (jwt, role) async {
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          final success = await authProvider.loginWithGoogleWebJwt(jwt, role);
          if (success && context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => widget.userRole == UserRole.teacher
                    ? const TeacherDashboardScreen()
                    : const StudentDashboardScreen(),
              ),
            );
          }
        },
      );
    }
  }

  Future<void> _handleGoogleLogin(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (kIsWeb) {
      // Sur web, on invite à utiliser le bouton natif
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Veuillez utiliser le bouton Google affiché ci-dessous pour vous connecter.'),
        ),
      );
      return;
    }

    final success = await authProvider.loginWithGoogle(widget.userRole);

    if (success && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => widget.userRole == UserRole.teacher
              ? const TeacherDashboardScreen()
              : const StudentDashboardScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(authProvider.errorMessage ?? 'Erreur de connexion Google'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final badge = widget.userRole == UserRole.teacher
        ? 'Espace Professeur'
        : 'Espace Étudiant';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // 🔽 Le bouton Flutter (mobile + fallback)
              ElevatedButton.icon(
                onPressed: () => _handleGoogleLogin(context),
                icon: const Icon(Icons.login),
                label: const Text('Connexion avec Google'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 🔽 Le bouton natif Google (affiché uniquement sur Web)
              if (kIsWeb)
                const SizedBox(
                  height: 60,
                  width: 300,
                  child: HtmlElementView(
                    viewType: 'google-sign-in-button',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
