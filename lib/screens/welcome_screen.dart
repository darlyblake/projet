import 'package:flutter/material.dart';
import 'package:edustore/models/user_model.dart';
import 'package:edustore/widgets/common/role_selection_card.dart';
import 'package:edustore/screens/auth/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2563EB),
              Color(0xFF7C3AED),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),

                  // Logo et titre
                  const Icon(
                    Icons.school,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'EduStore',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'La marketplace des cours en ligne',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connectez professeurs et étudiants',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  // Sélection de rôle
                  RoleSelectionCard(
                    icon: Icons.person_outline,
                    title: 'Je suis Professeur',
                    subtitle: 'Créez et vendez vos cours en ligne',
                    buttonText: 'Commencer à enseigner',
                    buttonColor: const Color(0xFF2563EB),
                    onPressed: () =>
                        _navigateToLogin(context, UserRole.teacher),
                  ),

                  const SizedBox(height: 16),

                  RoleSelectionCard(
                    icon: Icons.school_outlined,
                    title: 'Je suis Étudiant',
                    subtitle: 'Découvrez et achetez des cours',
                    buttonText: 'Commencer à apprendre',
                    buttonColor: const Color(0xFF16A34A),
                    onPressed: () =>
                        _navigateToLogin(context, UserRole.student),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToLogin(BuildContext context, UserRole role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(userRole: role),
      ),
    );
  }
}
