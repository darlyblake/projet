import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edustore/providers/auth_provider.dart';
import 'package:edustore/providers/course_provider.dart';
import 'package:edustore/widgets/common/bottom_navigation.dart';
import 'package:edustore/widgets/dashboard/stats_card.dart';
import 'package:edustore/widgets/analytics/revenue_chart_card.dart';
import 'package:edustore/widgets/analytics/course_performance_card.dart';


class TeacherAnalyticsScreen extends StatelessWidget {
  const TeacherAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revenus & Statistiques'),
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

          final averageRating = teacherCourses.isNotEmpty
              ? teacherCourses.fold<double>(0.0, (sum, course) => sum + course.rating) /
              teacherCourses.length
              : 0.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistiques principales
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'XAF Total',
                        value: '${(totalRevenue / 1000000).toStringAsFixed(1)}M',
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

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Cours créés',
                        value: teacherCourses.length.toString(),
                        icon: Icons.book,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        title: 'Note moyenne',
                        value: averageRating.toStringAsFixed(1),
                        icon: Icons.star,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Graphique des revenus
                const RevenueChartCard(),

                const SizedBox(height: 24),

                // Performance des cours
                CoursePerformanceCard(courses: teacherCourses),

                const SizedBox(height: 24),

                // Évolution mensuelle
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Évolution mensuelle',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildMonthlyItem('Décembre 2024', '3.8M XAF', '+12% vs Nov'),
                        _buildMonthlyItem('Novembre 2024', '4.2M XAF', '+31% vs Oct'),
                        _buildMonthlyItem('Octobre 2024', '3.2M XAF', '+8% vs Sep'),
                        _buildMonthlyItem('Septembre 2024', '2.9M XAF', '+15% vs Août'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 2),
    );
  }

  Widget _buildMonthlyItem(String month, String revenue, String growth) {
    final isPositive = growth.startsWith('+');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            month,
            style: const TextStyle(fontSize: 14),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                revenue,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(
                growth,
                style: TextStyle(
                  fontSize: 12,
                  color: isPositive ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
