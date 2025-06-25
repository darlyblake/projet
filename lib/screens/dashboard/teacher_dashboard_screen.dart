import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edustore/providers/auth_provider.dart';
import 'package:edustore/providers/course_provider.dart';
import 'package:edustore/widgets/common/bottom_navigation.dart';
import 'package:edustore/widgets/dashboard/stats_card.dart';
import 'package:edustore/widgets/dashboard/quick_actions_card.dart';
import 'package:edustore/widgets/dashboard/popular_courses_card.dart';
import 'package:edustore/screens/courses/create_course_screen.dart';
import 'package:edustore/screens/courses/my_courses_screen.dart';
import 'package:edustore/screens/analytics/teacher_analytics_screen.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Text('Bonjour ${authProvider.currentUser?.name ?? ''}');
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: Consumer2<AuthProvider, CourseProvider>(
        builder: (context, authProvider, courseProvider, child) {
          final teacherCourses = courseProvider.getCoursesByTeacher(
            authProvider.currentUser?.id ?? 0,
          );

          final totalRevenue = teacherCourses.fold<double>(
            0.0,
            (sum, course) => sum + course.revenue,
          );

          final totalStudents = teacherCourses.fold<int>(
            0,
            (sum, course) => sum + course.students,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistiques
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'XAF Total',
                        value:
                            '${(totalRevenue / 1000000).toStringAsFixed(1)}M',
                        icon: Icons.attach_money,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        title: 'Étudiants',
                        value: totalStudents.toString(),
                        icon: Icons.people,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Actions rapides
                QuickActionsCard(
                  actions: [
                    QuickAction(
                      title: 'Créer un nouveau cours',
                      icon: Icons.add,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateCourseScreen(),
                        ),
                      ),
                    ),
                    QuickAction(
                      title: 'Gérer mes cours (${teacherCourses.length})',
                      icon: Icons.book,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyCoursesScreen(),
                        ),
                      ),
                    ),
                    QuickAction(
                      title: 'Voir les statistiques',
                      icon: Icons.trending_up,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TeacherAnalyticsScreen(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Cours populaires
                PopularCoursesCard(
                  courses: teacherCourses.take(3).toList(),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
    );
  }
}
