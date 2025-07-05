import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edustore/models/course_model.dart';
import 'package:edustore/widgets/courses/course_price_badge.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onToggleFavorite;
  final bool isInCart;
  final bool isFavorite;
  final bool isPurchased;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.onAddToCart,
    this.onToggleFavorite,
    this.isInCart = false,
    this.isFavorite = false,
    this.isPurchased = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isTablet = width >= 600;

    final double imageHeight = isTablet ? 200 : 160;
    final double titleFontSize = isTablet ? 18 : 16;
    final double textFontSize = isTablet ? 14 : 12;
    final double smallFontSize = isTablet ? 12 : 11;
    final double padding = isTablet ? 20 : 16;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image avec badge & favori
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: course.image,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: imageHeight,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: imageHeight,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: CoursePriceBadge(
                    price: course.price ?? 0,
                    currency: course.currency,
                    isSmall: true,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          course.format == CourseFormat.video ? 'Vidéo' : 'PDF',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: smallFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (onToggleFavorite != null)
                        GestureDetector(
                          onTap: onToggleFavorite,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating & niveau
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: course.rating,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course.rating.toString(),
                            style: TextStyle(
                              fontSize: smallFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getLevelText(course.level),
                          style: TextStyle(
                            fontSize: smallFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Titre
                  Text(
                    course.title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Description
                  Text(
                    course.description,
                    style: TextStyle(
                      fontSize: textFontSize,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Professeur + durée
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Par ${course.teacher}',
                          style: TextStyle(
                            fontSize: smallFontSize,
                            color: Colors.grey.shade500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 2),
                          Text(
                            course.duration,
                            style: TextStyle(
                              fontSize: smallFontSize,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Étudiants & actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people,
                              size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            '${course.students} étudiants',
                            style: TextStyle(
                              fontSize: smallFontSize,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      if (isPurchased)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Text(
                            'Acheté',
                            style: TextStyle(
                              fontSize: textFontSize,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else if (course.isFree)
                        ElevatedButton.icon(
                          onPressed: onTap,
                          icon: const Icon(Icons.play_arrow, size: 16),
                          label: Text('Commencer',
                              style: TextStyle(fontSize: textFontSize)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                        )
                      else if (onAddToCart != null)
                        ElevatedButton.icon(
                          onPressed: isInCart ? null : onAddToCart,
                          icon: Icon(
                            isInCart ? Icons.check : Icons.shopping_cart,
                            size: 16,
                          ),
                          label: Text(
                            isInCart ? 'Ajouté' : 'Panier',
                            style: TextStyle(fontSize: textFontSize),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
