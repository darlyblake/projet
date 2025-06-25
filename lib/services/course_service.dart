import 'package:edustore/models/course_model.dart';
import 'package:edustore/utils/app_exception.dart';

class CourseService {
  // Données de démonstration
  static List<CourseModel> _mockCourses = [
    CourseModel(
      id: 1,
      title: "Développement Web Complet",
      description:
          "Apprenez HTML, CSS, JavaScript et React de A à Z avec des projets pratiques",
      price: 15000,
      currency: "XAF",
      format: CourseFormat.video,
      teacher: "Prof. Martin Kouam",
      teacherId: 1,
      image: "https://via.placeholder.com/300x200",
      students: 245,
      revenue: 3675000,
      rating: 4.8,
      duration: "12h 30min",
      lessons: 45,
      category: "Développement",
      level: CourseLevel.intermediate,
      createdAt: DateTime(2024, 1, 15),
      isPublished: true,
    ),
    CourseModel(
      id: 2,
      title: "Data Science avec Python",
      description:
          "Maîtrisez l'analyse de données et le machine learning avec Python",
      price: 20000,
      currency: "XAF",
      format: CourseFormat.pdf,
      teacher: "Dr. Sarah Mballa",
      teacherId: 2,
      image: "https://via.placeholder.com/300x200",
      students: 189,
      revenue: 3780000,
      rating: 4.9,
      duration: "8h 15min",
      lessons: 32,
      category: "Data Science",
      level: CourseLevel.advanced,
      createdAt: DateTime(2024, 2, 10),
      isPublished: true,
    ),
    CourseModel(
      id: 3,
      title: "Marketing Digital",
      description:
          "Stratégies complètes pour réussir en ligne : SEO, réseaux sociaux",
      price: 12000,
      currency: "XAF",
      format: CourseFormat.video,
      teacher: "Prof. Jean Nkomo",
      teacherId: 3,
      image: "https://via.placeholder.com/300x200",
      students: 312,
      revenue: 3744000,
      rating: 4.7,
      duration: "6h 45min",
      lessons: 28,
      category: "Marketing",
      level: CourseLevel.beginner,
      createdAt: DateTime(2024, 3, 5),
      isPublished: true,
    ),
  ];

  Future<List<CourseModel>> getAllCourses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockCourses);
  }

  Future<CourseModel> createCourse(CourseModel course) async {
    await Future.delayed(const Duration(seconds: 1));

    final newCourse = CourseModel(
      id: _mockCourses.length + 1,
      title: course.title,
      description: course.description,
      price: course.price,
      currency: course.currency,
      format: course.format,
      teacher: course.teacher,
      teacherId: course.teacherId,
      image: "https://via.placeholder.com/300x200",
      students: 0,
      revenue: 0,
      rating: 0,
      duration: course.duration,
      lessons: course.lessons,
      category: course.category,
      level: course.level,
      createdAt: DateTime.now(),
      isPublished: true,
    );

    _mockCourses.add(newCourse);
    return newCourse;
  }

  Future<void> updateCourse(CourseModel course) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockCourses.indexWhere((c) => c.id == course.id);
    if (index != -1) {
      _mockCourses[index] = course;
    }
  }

  Future<void> deleteCourse(int courseId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockCourses.removeWhere((course) => course.id == courseId);
  }

  /// 🔄 Méthode ajoutée : pour la pagination simulée
  Future<List<CourseModel>> getCoursesByPage(int page, int pageSize) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final start = (page - 1) * pageSize;
      if (start >= _mockCourses.length) return [];

      final end = (start + pageSize > _mockCourses.length)
          ? _mockCourses.length
          : start + pageSize;

      return _mockCourses.sublist(start, end);
    } catch (e) {
      throw AppException('Erreur lors de la pagination des cours');
    }
  }
}
