import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:edustore/models/course_model.dart';

class CourseProgressCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onTap;

  const CourseProgressCard({
    super.key,
    required this.course,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    final double imageSize = isTablet ? 80 : 60;
    final double titleFontSize = isTablet ? 16 : 14;
    final double subtitleFontSize = isTablet ? 14 : 12;
    final double iconSize = isTablet ? 36 : 32;
    final double lineHeight = isTablet ? 8 : 6;
    final double cardPadding = isTablet ? 24 : 16;
    final double labelFontSize = isTablet ? 13 : 12;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            children: [
              Row(
                children: [
                  // Image du cours
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

                  // Informations du cours
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: titleFontSize,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Par ${course.teacher}',
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bouton play
                  IconButton(
                    onPressed: onTap,
                    icon: Icon(
                      course.format == CourseFormat.video
                          ? Icons.play_circle_filled
                          : Icons.picture_as_pdf,
                      color: Colors.blue,
                      size: iconSize,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Barre de progression
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progression',
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${course.progress.toInt()}%',
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearPercentIndicator(
                    width: screenWidth -
                        (cardPadding * 2 + 32), // padding + iconButton
                    lineHeight: lineHeight,
                    percent: course.progress / 100,
                    backgroundColor: Colors.grey.shade200,
                    progressColor: Colors.blue,
                    barRadius: const Radius.circular(3),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
