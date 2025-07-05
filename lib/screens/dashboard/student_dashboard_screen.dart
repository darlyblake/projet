import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edustore/providers/auth_provider.dart';
import 'package:edustore/providers/course_provider.dart';
import 'package:edustore/providers/cart_provider.dart';

import 'package:edustore/widgets/common/bottom_navigation.dart';
import 'package:edustore/widgets/common/custom_text_field.dart';
import 'package:edustore/widgets/dashboard/stats_card.dart';
import 'package:edustore/widgets/dashboard/quick_actions_card.dart';
import 'package:edustore/widgets/courses/course_progress_card.dart';

import 'package:edustore/screens/courses/course_catalog_screen.dart';
import 'package:edustore/screens/courses/search_results_screen.dart';
import 'package:edustore/screens/purchases/my_purchases_screen.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Text('Bonjour ${authProvider.currentUser?.name ?? ''}');
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      // Naviguer vers le panier
                    },
                  ),
                  if (cartProvider.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartProvider.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer2<CourseProvider, CartProvider>(
        builder: (context, courseProvider, cartProvider, child) {
          final purchasedCourses = courseProvider.purchasedCourses;
          final completedCourses =
              purchasedCourses.where((course) => course.progress >= 80).length;
          final favorites = courseProvider.favorites;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isWide ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mes statistiques',
                  style: TextStyle(
                    fontSize: isWide ? 22 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: isWide ? (screenWidth - 64) / 3 : double.infinity,
                      child: StatsCard(
                        title: 'Cours achetés',
                        value: purchasedCourses.length.toString(),
                        icon: Icons.book,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width: isWide ? (screenWidth - 64) / 3 : double.infinity,
                      child: StatsCard(
                        title: 'Terminés',
                        value: completedCourses.toString(),
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      width: isWide ? (screenWidth - 64) / 3 : double.infinity,
                      child: StatsCard(
                        title: 'Favoris',
                        value: favorites.length.toString(),
                        icon: Icons.favorite,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _searchController,
                  label: 'Rechercher un cours...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResultsScreen(
                              query: _searchController.text,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
                QuickActionsCard(
                  actions: [
                    QuickAction(
                      title:
                          'Parcourir le catalogue (${courseProvider.courses.length} cours)',
                      icon: Icons.explore,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CourseCatalogScreen(),
                        ),
                      ),
                    ),
                    QuickAction(
                      title: 'Mes cours achetés (${purchasedCourses.length})',
                      icon: Icons.download,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyPurchasesScreen(),
                        ),
                      ),
                    ),
                    if (cartProvider.itemCount > 0)
                      QuickAction(
                        title:
                            'Finaliser mes achats (${cartProvider.itemCount})',
                        icon: Icons.shopping_cart,
                        onTap: () {
                          // Naviguer vers le paiement
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                if (purchasedCourses.isNotEmpty) ...[
                  Text(
                    'Continuer l\'apprentissage',
                    style: TextStyle(
                      fontSize: isWide ? 22 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...purchasedCourses.take(3).map(
                        (course) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CourseProgressCard(course: course),
                        ),
                      ),
                ],
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
    );
  }
}
