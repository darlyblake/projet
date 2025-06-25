import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:edustore/providers/course_provider.dart';
import 'package:edustore/providers/cart_provider.dart';

import 'package:edustore/models/course_model.dart';

import 'package:edustore/widgets/common/custom_button.dart';

import 'package:edustore/screens/courses/course_player_screen.dart';

class CourseDetailsScreen extends StatelessWidget {
  final CourseModel course;

  const CourseDetailsScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<CourseProvider, CartProvider>(
        builder: (context, courseProvider, cartProvider, child) {
          final isPurchased = courseProvider.isPurchased(course.id);
          final isInCart = cartProvider.isInCart(course.id);
          final isFavorite = courseProvider.isFavorite(course.id);

          return CustomScrollView(
            slivers: [
              // App Bar avec image
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        course.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 64,
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      courseProvider.toggleFavorite(course.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            courseProvider.isFavorite(course.id)
                                ? 'Ajouté aux favoris !'
                                : 'Retiré des favoris',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Partager le cours
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Partage à implémenter'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.share, color: Colors.white),
                  ),
                ],
              ),

              // Contenu
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badges et rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              course.format == CourseFormat.video
                                  ? 'Vidéo'
                                  : 'PDF',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: course.rating,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 16.0,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${course.rating} (${course.students} étudiants)',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Titre et description
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        course.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Informations du professeur et niveau
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Par ${course.teacher}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getLevelText(course.level),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Détails du cours
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(
                              Icons.access_time,
                              'Durée',
                              course.duration,
                            ),
                          ),
                          Expanded(
                            child: _buildDetailItem(
                              Icons.play_lesson,
                              'Leçons',
                              '${course.lessons} leçons',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Ce que vous apprendrez
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Ce que vous apprendrez',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildLearningItem(
                                  'Concepts fondamentaux et avancés'),
                              _buildLearningItem(
                                  'Exercices pratiques et projets réels'),
                              _buildLearningItem('Accès à vie au contenu'),
                              _buildLearningItem('Support de l\'instructeur'),
                              _buildLearningItem('Certificat de completion'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Prix et garantie
                      Card(
                        color: Colors.grey.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Prix du cours',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${(course.price ?? 0).toStringAsFixed(0)} ${course.currency}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Accès à vie • Garantie 30 jours',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Boutons d'action
                      if (isPurchased) ...[
                        CustomButton(
                          text: course.format == CourseFormat.video
                              ? 'Commencer le cours'
                              : 'Ouvrir le cours',
                          icon: course.format == CourseFormat.video
                              ? Icons.play_arrow
                              : Icons.picture_as_pdf,
                          backgroundColor: Colors.blue,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CoursePlayerScreen(
                                course: course,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        CustomButton(
                          text: 'Acheter maintenant',
                          icon: Icons.credit_card,
                          backgroundColor: Colors.green,
                          onPressed: () {
                            // Navigate to payment
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Paiement à implémenter'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomButton(
                          text: isInCart
                              ? 'Ajouté au panier'
                              : 'Ajouter au panier',
                          icon: isInCart ? Icons.check : Icons.shopping_cart,
                          isOutlined: true,
                          onPressed: isInCart
                              ? null
                              : () {
                                  cartProvider.addToCart(course);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Cours ajouté au panier !'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                        ),
                      ],

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLearningItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _getLevelText(CourseLevel level) {
    switch (level) {
      case CourseLevel.beginner:
        return 'Débutant';
      case CourseLevel.intermediate:
        return 'Intermédiaire';
      case CourseLevel.advanced:
        return 'Avancé';
    }
  }
}
