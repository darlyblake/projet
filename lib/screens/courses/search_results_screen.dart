import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edustore/providers/course_provider.dart';
import 'package:edustore/providers/cart_provider.dart';
import 'package:edustore/widgets/courses/course_card.dart';
import 'package:edustore/screens/courses/course_details_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({
    super.key,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats pour "$query"'),
      ),
      body: Consumer2<CourseProvider, CartProvider>(
        builder: (context, courseProvider, cartProvider, child) {
          final searchResults = courseProvider.searchCourses(query);

          return searchResults.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final course = searchResults[index];
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
                        },
                        isInCart: cartProvider.isInCart(course.id),
                        isFavorite: courseProvider.isFavorite(course.id),
                        isPurchased: courseProvider.isPurchased(course.id),
                      ),
                    );
                  },
                );
        },
      ),
    );
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
            'Aucun résultat trouvé',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Essayez avec d\'autres mots-clés',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
