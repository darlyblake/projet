import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edustore/providers/auth_provider.dart';
import 'package:edustore/providers/course_provider.dart';

import 'package:edustore/widgets/common/bottom_navigation.dart';
import 'package:edustore/widgets/common/custom_button.dart';
import 'package:edustore/widgets/courses/teacher_course_card.dart';

import 'package:edustore/screens/courses/create_course_screen.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes cours'),
      ),
      body: Consumer2<AuthProvider, CourseProvider>(
        builder: (context, authProvider, courseProvider, child) {
          final teacherCourses = courseProvider.getCoursesByTeacher(
            authProvider.currentUser?.id ?? '',
          );

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Bouton créer un cours
                CustomButton(
                  text: 'Créer un nouveau cours',
                  icon: Icons.add,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateCourseScreen(),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Liste des cours
                Expanded(
                  child: teacherCourses.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          itemCount: teacherCourses.length,
                          itemBuilder: (context, index) {
                            final course = teacherCourses[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: TeacherCourseCard(
                                course: course,
                                onEdit: () => _editCourse(context, course),
                                onDelete: () => _deleteCourse(context, course),
                                onViewStats: () => _viewStats(context, course),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 1),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun cours créé',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Commencez par créer votre premier cours',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Créer un cours',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateCourseScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editCourse(BuildContext context, course) {
    // Navigate to edit course screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Édition à implémenter')),
    );
  }

  void _deleteCourse(BuildContext context, course) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer le cours'),
          content:
              Text('Êtes-vous sûr de vouloir supprimer "${course.title}" ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<CourseProvider>(context, listen: false)
                    .deleteCourse(course.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cours supprimé'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child:
                  const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _viewStats(BuildContext context, course) {
    // Navigate to course analytics
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Statistiques à implémenter')),
    );
  }
}
