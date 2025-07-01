import 'package:flutter/material.dart';
import 'package:edustore/models/course_model.dart';

class PurchasedCourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onPlay;
  final Function(double) onUpdateProgress;

  const PurchasedCourseCard({
    super.key,
    required this.course,
    required this.onPlay,
    required this.onUpdateProgress,
  });

  @override
  Widget build(BuildContext context) {
    final progress = course.progress;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image du cours
                Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                  ),
                  child: const Icon(
                    Icons.play_circle_fill,
                    color: Colors.blue,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),

                // Informations du cours
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.teacher,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Barre de progression
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progression',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onPlay,
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: Text(progress > 0 ? 'Continuer' : 'Commencer'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Bouton pour simuler la progression
                if (progress < 1.0)
                  OutlinedButton(
                    onPressed: () {
                      final newProgress = (progress + 0.1).clamp(0.0, 1.0);
                      onUpdateProgress(newProgress);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    child: const Text('+10%'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
