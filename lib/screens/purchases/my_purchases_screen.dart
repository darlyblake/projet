import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edustore/providers/course_provider.dart';
import 'package:edustore/widgets/common/bottom_navigation.dart';
import 'package:edustore/widgets/courses/purchased_course_card.dart';
import 'package:edustore/screens/courses/course_catalog_screen.dart';
import 'package:edustore/screens/courses/course_player_screen.dart';

class MyPurchasesScreen extends StatelessWidget {
  const MyPurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes achats'),
      ),
      body: Consumer<CourseProvider>(
        builder: (context, courseProvider, child) {
          final purchasedCourses = courseProvider.purchasedCourses;

          return purchasedCourses.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: purchasedCourses.length,
                  itemBuilder: (context, index) {
                    final course = purchasedCourses[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PurchasedCourseCard(
                        course: course,
                        onPlay: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoursePlayerScreen(
                              course: course,
                            ),
                          ),
                        ),
                        onUpdateProgress: (progress) {
                          courseProvider.updateProgress(course.id, progress);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Progression mise à jour !'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
        },
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 2),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun cours acheté',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explorez notre catalogue pour commencer à apprendre',
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CourseCatalogScreen(),
                ),
              ),
              child: const Text('Parcourir les cours'),
            ),
          ],
        ),
      ),
    );
  }
}
