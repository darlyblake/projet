import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edustore/providers/auth_provider.dart';
import 'package:edustore/providers/course_provider.dart';
import 'package:edustore/models/user_model.dart';
import 'package:edustore/widgets/common/bottom_navigation.dart';
import 'package:edustore/widgets/common/custom_button.dart';
import 'package:edustore/screens/welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Profil')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700;

          return Consumer2<AuthProvider, CourseProvider>(
            builder: (context, authProvider, courseProvider, child) {
              final user = authProvider.currentUser;
              if (user == null) {
                return const Center(child: Text('Utilisateur non connecté'));
              }

              final bool isTeacher = user.role == UserRole.teacher;
              final List teacherCourses =
                  isTeacher ? courseProvider.getCoursesByTeacher(user.id) : [];
              final List purchasedCourses = courseProvider.purchasedCourses;
              final List favorites = courseProvider.favorites;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _buildProfileCard(user, isTeacher),
                                const SizedBox(height: 16),
                                _buildSettingsCard(context),
                                const SizedBox(height: 16),
                                _buildLogoutButton(context, authProvider),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _buildStatsCard(isTeacher, teacherCourses,
                                purchasedCourses, favorites),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildProfileCard(user, isTeacher),
                          const SizedBox(height: 24),
                          _buildStatsCard(isTeacher, teacherCourses,
                              purchasedCourses, favorites),
                          const SizedBox(height: 24),
                          _buildSettingsCard(context),
                          const SizedBox(height: 24),
                          _buildLogoutButton(context, authProvider),
                        ],
                      ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 3),
    );
  }

  Widget _buildProfileCard(UserModel user, bool isTeacher) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),
            Text(user.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(user.email, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                isTeacher ? 'Professeur' : 'Étudiant',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8),
            Text('Membre depuis ${_formatDate(user.joinDate)}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(bool isTeacher, List teacherCourses,
      List purchasedCourses, List favorites) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Statistiques',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: isTeacher
                      ? _buildStatItem(
                          'Cours créés',
                          teacherCourses.length.toString(),
                          Icons.book,
                          Colors.blue)
                      : _buildStatItem(
                          'Cours achetés',
                          purchasedCourses.length.toString(),
                          Icons.shopping_cart,
                          Colors.blue),
                ),
                Expanded(
                  child: isTeacher
                      ? _buildStatItem(
                          'Étudiants',
                          teacherCourses
                              .fold<num>(0,
                                  (sum, course) => sum + (course.students ?? 0))
                              .toString(),
                          Icons.people,
                          Colors.green,
                        )
                      : _buildStatItem('Favoris', favorites.length.toString(),
                          Icons.favorite, Colors.purple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Paramètres',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildSettingsItem('Modifier le profil', Icons.edit,
                () => _showComingSoon(context)),
            _buildSettingsItem('Changer le mot de passe', Icons.lock,
                () => _showComingSoon(context)),
            _buildSettingsItem('Méthodes de paiement', Icons.credit_card,
                () => _showComingSoon(context)),
            _buildSettingsItem('Notifications', Icons.notifications,
                () => _showComingSoon(context)),
            _buildSettingsItem(
                'Aide et support', Icons.help, () => _showComingSoon(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    return CustomButton(
      text: 'Se déconnecter',
      icon: Icons.logout,
      backgroundColor: Colors.red.shade50,
      textColor: Colors.red,
      isOutlined: true,
      onPressed: () => _logout(context, authProvider),
    );
  }

  Widget _buildStatItem(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité à venir !'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _logout(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Etes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                authProvider.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                  (route) => false,
                );
              },
              child: const Text('Déconnecter',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
