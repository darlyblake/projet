import 'package:edustore/models/course_model.dart';

class TeacherAnalyticsService {
  final List<CourseModel> teacherCourses;

  TeacherAnalyticsService(this.teacherCourses);

  double get totalRevenue =>
      teacherCourses.fold(0.0, (sum, course) => sum + course.revenue);

  int get totalStudents =>
      teacherCourses.fold(0, (sum, course) => sum + course.students);

  int get totalCourses => teacherCourses.length;

  double get averageRating {
    if (teacherCourses.isEmpty) return 0.0;
    final totalRating =
        teacherCourses.fold(0.0, (sum, course) => sum + course.rating);
    return totalRating / teacherCourses.length;
  }

  // Pour l'exemple, je laisse fixe mais tu peux passer une source de données dynamique
  List<Map<String, String>> get monthlyEvolution => [
        {
          'month': 'Décembre 2024',
          'revenue': '3.8M XAF',
          'growth': '+12% vs Nov'
        },
        {
          'month': 'Novembre 2024',
          'revenue': '4.2M XAF',
          'growth': '+31% vs Oct'
        },
        {
          'month': 'Octobre 2024',
          'revenue': '3.2M XAF',
          'growth': '+8% vs Sep'
        },
        {
          'month': 'Septembre 2024',
          'revenue': '2.9M XAF',
          'growth': '+15% vs Août'
        },
      ];
}
