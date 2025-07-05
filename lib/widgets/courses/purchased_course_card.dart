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
    final width = MediaQuery.of(context).size.width;

    final isWide = width > 700;
    final imageWidth = isWide ? 100.0 : 80.0;
    final imageHeight = isWide ? 80.0 : 60.0;
    final fontSizeTitle = isWide ? 18.0 : 16.0;
    final fontSizeSubtitle = isWide ? 16.0 : 14.0;
    final padding = isWide ? 20.0 : 16.0;

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: imageWidth,
                  height: imageHeight,
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
                SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: isWide ? 8.0 : 0,
                      top: isWide ? 0 : 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: TextStyle(
                            fontSize: fontSizeTitle,
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
                            fontSize: fontSizeSubtitle,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onPlay,
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: Text(progress > 0 ? 'Continuer' : 'Commencer'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      textStyle: TextStyle(
                        fontSize: isWide ? 16 : 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (progress < 1.0)
                  OutlinedButton(
                    onPressed: () {
                      final newProgress = (progress + 0.1).clamp(0.0, 1.0);
                      onUpdateProgress(newProgress);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 16 : 12,
                        vertical: 10,
                      ),
                      textStyle: TextStyle(
                        fontSize: isWide ? 14 : 12,
                      ),
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
