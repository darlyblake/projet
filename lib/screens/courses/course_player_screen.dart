import 'package:flutter/material.dart';
import 'package:edustore/models/course_model.dart';

class CoursePlayerScreen extends StatefulWidget {
  final CourseModel course;

  const CoursePlayerScreen({
    super.key,
    required this.course,
  });

  @override
  State<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
}

class _CoursePlayerScreenState extends State<CoursePlayerScreen> {
  int currentLesson = 0;
  final List<String> lessons = [
    'Introduction au cours',
    'Chapitre 1: Les bases',
    'Chapitre 2: Concepts avancés',
    'Chapitre 3: Pratique',
    'Conclusion et ressources',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Marque-page ajouté !')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Lecteur vidéo simulé
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.black,
            child: const Center(
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 64,
              ),
            ),
          ),

          // Contrôles de lecture
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: currentLesson > 0
                      ? () {
                          setState(() {
                            currentLesson--;
                          });
                        }
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.replay_10),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.play_arrow, size: 32),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.forward_10),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: currentLesson < lessons.length - 1
                      ? () {
                          setState(() {
                            currentLesson++;
                          });
                        }
                      : null,
                ),
              ],
            ),
          ),

          const Divider(),

          // Liste des leçons
          Expanded(
            child: ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final isCurrentLesson = index == currentLesson;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        isCurrentLesson ? Colors.blue : Colors.grey.shade300,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isCurrentLesson
                            ? Colors.white
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    lessons[index],
                    style: TextStyle(
                      fontWeight:
                          isCurrentLesson ? FontWeight.bold : FontWeight.normal,
                      color: isCurrentLesson ? Colors.blue : null,
                    ),
                  ),
                  trailing: index < currentLesson
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() {
                      currentLesson = index;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
