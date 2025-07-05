import 'package:flutter/material.dart';
import 'package:edustore/models/user_model.dart';
import 'package:edustore/widgets/common/role_selection_card.dart';
import 'package:edustore/screens/auth/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Tailles dynamiques selon largeur
    final iconSize = screenWidth > 600 ? 120.0 : 80.0;
    final titleFontSize = screenWidth > 600 ? 64.0 : 48.0;
    final subtitleFontSize = screenWidth > 600 ? 24.0 : 18.0;
    final smallTextFontSize = screenWidth > 600 ? 18.0 : 14.0;

    final buttonHeight = screenWidth > 600 ? 60.0 : 48.0;
    final buttonFontSize = screenWidth > 600 ? 20.0 : 16.0;

    final horizontalPadding = screenWidth > 900 ? 64.0 : 24.0;
    final verticalSpacing = screenWidth > 600 ? 32.0 : 16.0;

    final isWideScreen = screenWidth > 700;

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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalSpacing),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: verticalSpacing * 1.5),

                      Icon(
                        Icons.school,
                        size: iconSize,
                        color: Colors.white,
                      ),
                      SizedBox(height: verticalSpacing / 2),

                      Text(
                        'EduStore',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: verticalSpacing / 3),

                      Text(
                        'La marketplace des cours en ligne',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: verticalSpacing / 5),

                      Text(
                        'Connectez professeurs et étudiants',
                        style: TextStyle(
                          fontSize: smallTextFontSize,
                          color: Colors.white60,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: verticalSpacing * 1.5),

                      // Layout adaptatif des cartes rôle
                      isWideScreen
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: RoleSelectionCard(
                                    icon: Icons.person_outline,
                                    title: 'Je suis Professeur',
                                    subtitle:
                                        'Créez et vendez vos cours en ligne',
                                    buttonText: 'Commencer à enseigner',
                                    buttonColor: const Color(0xFF2563EB),
                                    buttonHeight: buttonHeight,
                                    buttonFontSize: buttonFontSize,
                                    onPressed: () => _navigateToLogin(
                                        context, UserRole.teacher),
                                  ),
                                ),
                                SizedBox(width: horizontalPadding / 2),
                                Expanded(
                                  child: RoleSelectionCard(
                                    icon: Icons.school_outlined,
                                    title: 'Je suis Étudiant',
                                    subtitle: 'Découvrez et achetez des cours',
                                    buttonText: 'Commencer à apprendre',
                                    buttonColor: const Color(0xFF16A34A),
                                    buttonHeight: buttonHeight,
                                    buttonFontSize: buttonFontSize,
                                    onPressed: () => _navigateToLogin(
                                        context, UserRole.student),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                RoleSelectionCard(
                                  icon: Icons.person_outline,
                                  title: 'Je suis Professeur',
                                  subtitle:
                                      'Créez et vendez vos cours en ligne',
                                  buttonText: 'Commencer à enseigner',
                                  buttonColor: const Color(0xFF2563EB),
                                  buttonHeight: buttonHeight,
                                  buttonFontSize: buttonFontSize,
                                  onPressed: () => _navigateToLogin(
                                      context, UserRole.teacher),
                                ),
                                SizedBox(height: verticalSpacing),
                                RoleSelectionCard(
                                  icon: Icons.school_outlined,
                                  title: 'Je suis Étudiant',
                                  subtitle: 'Découvrez et achetez des cours',
                                  buttonText: 'Commencer à apprendre',
                                  buttonColor: const Color(0xFF16A34A),
                                  buttonHeight: buttonHeight,
                                  buttonFontSize: buttonFontSize,
                                  onPressed: () => _navigateToLogin(
                                      context, UserRole.student),
                                ),
                              ],
                            ),

                      SizedBox(height: verticalSpacing * 1.5),
                    ],
                  ),
                ),
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
