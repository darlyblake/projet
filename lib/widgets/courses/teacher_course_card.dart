import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:edustore/models/course_model.dart';

class TeacherCourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onViewStats;

  const TeacherCourseCard({
    super.key,
    required this.course,
    this.onEdit,
    this.onDelete,
    this.onViewStats,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 700;

    final imageSize = isWide ? 100.0 : 80.0;
    final fontSizeTitle = isWide ? 16.0 : 14.0;
    final fontSizeText = isWide ? 13.0 : 11.0;
    final verticalPadding = isWide ? 20.0 : 16.0;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(verticalPadding),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    course.image,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: imageSize,
                        height: imageSize,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre et badge publié
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              course.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSizeTitle,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: course.isPublished
                                  ? Colors.green.shade50
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: course.isPublished
                                    ? Colors.green.shade200
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              course.isPublished ? 'Publié' : 'Brouillon',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: course.isPublished
                                    ? Colors.green.shade700
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.description,
                        style: TextStyle(
                          fontSize: fontSizeText,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${course.students} étudiants',
                            style: TextStyle(
                              fontSize: fontSizeText,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          RatingBarIndicator(
                            rating: course.rating,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 12.0,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course.rating.toString(),
                            style: TextStyle(
                              fontSize: fontSizeText,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(course.price ?? 0).toStringAsFixed(0)} ${course.currency}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Revenus: ${(course.revenue / 1000).toStringAsFixed(0)}K XAF',
                            style: TextStyle(
                              fontSize: fontSizeText,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            isWide
                ? Row(
                    children: _buildActionButtons(context, isWide),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildActionButtons(context, isWide),
                  ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context, bool isWide) {
    final spacing =
        isWide ? const SizedBox(width: 8) : const SizedBox(height: 8);
    return [
      Expanded(
        child: OutlinedButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Modifier'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ),
      spacing,
      Expanded(
        child: OutlinedButton.icon(
          onPressed: onViewStats,
          icon: const Icon(Icons.bar_chart, size: 16),
          label: const Text('Stats'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ),
      spacing,
      OutlinedButton(
        onPressed: onDelete,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: const Icon(Icons.delete, size: 16),
      ),
    ];
  }
}
