import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edustore/providers/course_provider.dart';
import 'package:edustore/providers/cart_provider.dart';

import 'package:edustore/widgets/common/bottom_navigation.dart';
import 'package:edustore/widgets/common/custom_text_field.dart';
import 'package:edustore/widgets/courses/course_card.dart';

import 'package:edustore/screens/courses/search_results_screen.dart';
import 'package:edustore/screens/courses/course_details_screen.dart';


class CourseCatalogScreen extends StatefulWidget {
  const CourseCatalogScreen({super.key});

  @override
  State<CourseCatalogScreen> createState() => _CourseCatalogScreenState();
}

class _CourseCatalogScreenState extends State<CourseCatalogScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'Tous';
  String _selectedLevel = 'Tous';

  final List<String> _categories = [
    'Tous',
    'Développement',
    'Design',
    'Marketing',
    'Data Science',
    'Business',
  ];

  final List<String> _levels = [
    'Tous',
    'Débutant',
    'Intermédiaire',
    'Avancé',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue des cours'),
      ),
      body: Consumer2<CourseProvider, CartProvider>(
        builder: (context, courseProvider, cartProvider, child) {
          final filteredCourses = _getFilteredCourses(courseProvider.courses);

          return Column(
            children: [
              // Barre de recherche et filtres
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey.shade50,
                child: Column(
                  children: [
                    // Recherche
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

                    const SizedBox(height: 16),

                    // Filtres
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: const InputDecoration(
                              labelText: 'Catégorie',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            items: _categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedLevel,
                            decoration: const InputDecoration(
                              labelText: 'Niveau',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            items: _levels.map((level) {
                              return DropdownMenuItem(
                                value: level,
                                child: Text(level),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedLevel = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Résultats
              Expanded(
                child: filteredCourses.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredCourses.length,
                  itemBuilder: (context, index) {
                    final course = filteredCourses[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CourseCard(
                        course: course,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetailsScreen(
                              course: course,
                            ),
                          ),
                        ),
                        onAddToCart: () {
                          cartProvider.addToCart(course);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cours ajouté au panier !'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        onToggleFavorite: () {
                          courseProvider.toggleFavorite(course.id);
                          final isFavorite = courseProvider.isFavorite(course.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite
                                    ? 'Ajouté aux favoris !'
                                    : 'Retiré des favoris',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        isInCart: cartProvider.isInCart(course.id),
                        isFavorite: courseProvider.isFavorite(course.id),
                        isPurchased: courseProvider.isPurchased(course.id),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 1),
    );
  }

  List<dynamic> _getFilteredCourses(List<dynamic> courses) {
    return courses.where((course) {
      // Filtre par catégorie
      if (_selectedCategory != 'Tous' && course.category != _selectedCategory) {
        return false;
      }

      // Filtre par niveau
      if (_selectedLevel != 'Tous') {
        final levelText = _getLevelText(course.level);
        if (levelText != _selectedLevel) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  String _getLevelText(dynamic level) {
    if (level.toString().contains('beginner')) return 'Débutant';
    if (level.toString().contains('intermediate')) return 'Intermédiaire';
    if (level.toString().contains('advanced')) return 'Avancé';
    return 'Débutant';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun cours trouvé',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Essayez de modifier vos filtres',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
