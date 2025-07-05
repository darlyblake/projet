import 'package:flutter/material.dart';

import 'package:edustore/providers/course_provider.dart';
import 'package:edustore/providers/auth_provider.dart';
import 'package:edustore/services/teacher_analytics_service.dart';

class TeacherAnalyticsProvider extends ChangeNotifier {
  final AuthProvider authProvider;
  final CourseProvider courseProvider;

  TeacherAnalyticsService? _service;

  TeacherAnalyticsProvider({
    required this.authProvider,
    required this.courseProvider,
  }) {
    _loadAnalytics();
  }

  TeacherAnalyticsService? get service => _service;

  void _loadAnalytics() {
    final userId = authProvider.currentUser?.id;
    if (userId == null) {
      _service = null;
    } else {
      final teacherCourses = courseProvider.getCoursesByTeacher(userId);
      _service = TeacherAnalyticsService(teacherCourses);
    }
    notifyListeners();
  }

  // Si tu veux rafraîchir les données plus tard
  void refresh() {
    _loadAnalytics();
  }
}
