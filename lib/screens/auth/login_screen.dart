import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edustore/providers/auth_provider.dart';
import 'package:edustore/models/user_model.dart';

import 'package:edustore/widgets/common/custom_button.dart';
import 'package:edustore/widgets/common/custom_text_field.dart';
import 'package:edustore/widgets/common/loading_overlay.dart';

import 'package:edustore/screens/dashboard/teacher_dashboard_screen.dart';
import 'package:edustore/screens/dashboard/student_dashboard_screen.dart';
import 'package:edustore/screens/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  final UserRole userRole;

  const LoginScreen({super.key, required this.userRole});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLargeScreen = width > 600;
    final horizontalPadding = isLargeScreen ? 64.0 : 24.0;
    final badgeFontSize = isLargeScreen ? 20.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return LoadingOverlay(
            isLoading: authProvider.isLoading,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: 24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 32),

                        // Badge de rôle
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.userRole == UserRole.teacher
                                  ? 'Espace Professeur'
                                  : 'Espace Étudiant',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: badgeFontSize,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Formulaire
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir votre email';
                            }
                            if (!value.contains('@')) {
                              return 'Email invalide';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _passwordController,
                          label: 'Mot de passe',
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir votre mot de passe';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        // Message d'erreur
                        if (authProvider.errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Text(
                              authProvider.errorMessage!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),

                        // Bouton de connexion
                        CustomButton(
                          text: 'Se connecter',
                          onPressed: _handleLogin,
                          isLoading: authProvider.isLoading,
                        ),

                        const SizedBox(height: 16),

                        // Lien vers inscription
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Pas encore de compte ? '),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(
                                      userRole: widget.userRole,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('S\'inscrire'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
      widget.userRole,
    );

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget.userRole == UserRole.teacher
              ? const TeacherDashboardScreen()
              : const StudentDashboardScreen(),
        ),
        (route) => false,
      );
    }
  }
}
