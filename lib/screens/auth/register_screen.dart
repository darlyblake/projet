import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edustore/providers/auth_provider.dart';
import 'package:edustore/models/user_model.dart';

import 'package:edustore/widgets/common/custom_button.dart';
import 'package:edustore/widgets/common/custom_text_field.dart';
import 'package:edustore/widgets/common/loading_overlay.dart';

import 'package:edustore/screens/dashboard/teacher_dashboard_screen.dart';
import 'package:edustore/screens/dashboard/student_dashboard_screen.dart';
import 'package:edustore/screens/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final UserRole userRole;

  const RegisterScreen({super.key, required this.userRole});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer largeur écran
    final width = MediaQuery.of(context).size.width;
    final isLargeScreen = width > 600;
    final horizontalPadding = isLargeScreen ? 64.0 : 24.0;
    final badgeFontSize = isLargeScreen ? 20.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
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
                                  ? 'Nouveau Professeur'
                                  : 'Nouvel Étudiant',
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
                          controller: _nameController,
                          label: 'Nom complet',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir votre nom';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

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
                              return 'Veuillez saisir un mot de passe';
                            }
                            if (value.length < 6) {
                              return 'Le mot de passe doit contenir au moins 6 caractères';
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

                        // Bouton d'inscription
                        CustomButton(
                          text: 'Créer mon compte',
                          onPressed: _handleRegister,
                          isLoading: authProvider.isLoading,
                        ),

                        const SizedBox(height: 16),

                        // Lien vers connexion
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Déjà un compte ? '),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(
                                      userRole: widget.userRole,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Se connecter'),
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

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.register(
      _nameController.text.trim(),
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
        (route) => false, // Supprime toute la pile précédente
      );
    }
  }
}
