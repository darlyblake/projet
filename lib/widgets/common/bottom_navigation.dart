import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edustore/providers/auth_provider.dart';
import 'package:edustore/models/user_model.dart';
import 'package:edustore/screens/dashboard/teacher_dashboard_screen.dart';
import 'package:edustore/screens/dashboard/student_dashboard_screen.dart';
import 'package:edustore/screens/courses/my_courses_screen.dart';
import 'package:edustore/screens/courses/course_catalog_screen.dart';
import 'package:edustore/screens/analytics/teacher_analytics_screen.dart';
import 'package:edustore/screens/purchases/my_purchases_screen.dart';
import 'package:edustore/screens/profile/profile_screen.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isTeacher = authProvider.currentUser?.role == UserRole.teacher;

        return BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2563EB),
          unselectedItemColor: Colors.grey,
          onTap: (index) => _onItemTapped(context, index, isTeacher),
          items: isTeacher
              ? const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Accueil',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book),
                    label: 'Mes Cours',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.trending_up),
                    label: 'Revenus',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profil',
                  ),
                ]
              : const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Accueil',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book),
                    label: 'Catalogue',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart),
                    label: 'Mes Achats',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profil',
                  ),
                ],
        );
      },
    );
  }

  void _onItemTapped(BuildContext context, int index, bool isTeacher) {
    if (index == currentIndex) return;

    Widget destination;

    if (isTeacher) {
      switch (index) {
        case 0:
          destination = const TeacherDashboardScreen();
          break;
        case 1:
          destination = const MyCoursesScreen();
          break;
        case 2:
          destination = const TeacherAnalyticsScreen();
          break;
        case 3:
          destination = const ProfileScreen();

          break;
        default:
          return;
      }
    } else {
      switch (index) {
        case 0:
          destination = const StudentDashboardScreen();
          break;
        case 1:
          destination = const CourseCatalogScreen();
          break;
        case 2:
          destination = const MyPurchasesScreen();
          break;
        case 3:
          destination = const ProfileScreen();

          break;
        default:
          return;
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
