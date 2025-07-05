import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edustore/providers/auth_provider.dart';
import 'package:edustore/providers/course_provider.dart';
import 'package:edustore/widgets/common/bottom_navigation.dart';
import 'package:edustore/widgets/dashboard/stats_card.dart';
import 'package:edustore/widgets/analytics/revenue_chart_card.dart';
import 'package:edustore/widgets/analytics/course_performance_card.dart';
import 'package:edustore/providers/teacher_analytics_provider.dart';

class TeacherAnalyticsScreen extends StatelessWidget {
  const TeacherAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeacherAnalyticsProvider(
        authProvider: Provider.of<AuthProvider>(context, listen: false),
        courseProvider: Provider.of<CourseProvider>(context, listen: false),
      ),
      child: const _TeacherAnalyticsView(),
    );
  }
}

class _TeacherAnalyticsView extends StatelessWidget {
  const _TeacherAnalyticsView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherAnalyticsProvider>();
    final service = provider.service;

    if (service == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Revenus & Statistiques')),
        body: const Center(child: Text('Utilisateur non connecté')),
      );
    }

    // Responsive : on adapte la grille selon la largeur
    return Scaffold(
      appBar: AppBar(title: const Text('Revenus & Statistiques')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grille des stats principales
                isWide
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: StatsCard(
                              title: 'XAF Total',
                              value:
                                  '${(service.totalRevenue / 1000000).toStringAsFixed(1)}M',
                              icon: Icons.attach_money,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: StatsCard(
                              title: 'Étudiants',
                              value: service.totalStudents.toString(),
                              icon: Icons.people,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: StatsCard(
                              title: 'Cours créés',
                              value: service.totalCourses.toString(),
                              icon: Icons.book,
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: StatsCard(
                              title: 'Note moyenne',
                              value: service.averageRating.toStringAsFixed(1),
                              icon: Icons.star,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: StatsCard(
                                  title: 'XAF Total',
                                  value:
                                      '${(service.totalRevenue / 1000000).toStringAsFixed(1)}M',
                                  icon: Icons.attach_money,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: StatsCard(
                                  title: 'Étudiants',
                                  value: service.totalStudents.toString(),
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
                                  value: service.totalCourses.toString(),
                                  icon: Icons.book,
                                  color: Colors.purple,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: StatsCard(
                                  title: 'Note moyenne',
                                  value:
                                      service.averageRating.toStringAsFixed(1),
                                  icon: Icons.star,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                const SizedBox(height: 24),

                // Graphique des revenus
                const RevenueChartCard(),

                const SizedBox(height: 24),

                // Performance des cours
                CoursePerformanceCard(courses: service.teacherCourses),

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
                        ...service.monthlyEvolution
                            .map((entry) => _buildMonthlyItem(
                                  entry['month']!,
                                  entry['revenue']!,
                                  entry['growth']!,
                                )),
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
