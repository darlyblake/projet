import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:edustore/models/course_model.dart';
import 'package:edustore/services/course_service.dart';
import 'package:edustore/utils/app_exception.dart';

class CourseProvider with ChangeNotifier {
  final CourseService _courseService = CourseService();

  String _selectedCategory = 'Tous';
  String _selectedLevel = 'Tous';

  String get selectedCategory => _selectedCategory;
  set selectedCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  String get selectedLevel => _selectedLevel;
  set selectedLevel(String value) {
    _selectedLevel = value;
    notifyListeners();
  }

  List<CourseModel> _courses = [];
  final List<CourseModel> _purchasedCourses = [];
  final List<String> _favorites = []; // <-- ici String au lieu de int

  bool _isLoading = false;
  String? _errorMessage;

  int _currentPage = 1;
  final int _pageSize = 10;

  List<CourseModel> get courses => _courses;
  List<CourseModel> get purchasedCourses => _purchasedCourses;
  List<String> get favorites => _favorites; // <-- String
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  CourseProvider() {
    loadCourses();
  }

  Future<void> loadCourses() async {
    _setLoading(true);
    _clearError();
    try {
      final newCourses = await _courseService.getAllCourses();
      _courses = newCourses;
    } catch (e) {
      _setError(_handleException(e));
    }
    _setLoading(false);
  }

  List<CourseModel> get filteredCourses {
    return _courses.where((course) {
      if (_selectedCategory != 'Tous' && course.category != _selectedCategory) {
        return false;
      }
      if (_selectedLevel != 'Tous') {
        final levelText = _getLevelText(course.level);
        if (levelText != _selectedLevel) return false;
      }
      return true;
    }).toList();
  }

  String _getLevelText(dynamic level) {
    if (level.toString().contains('beginner')) return 'Débutant';
    if (level.toString().contains('intermediate')) return 'Intermédiaire';
    if (level.toString().contains('advanced')) return 'Avancé';
    return 'Débutant';
  }

  void sortCourses(String key, {bool ascending = true}) {
    Comparator<CourseModel> comparator;
    switch (key) {
      case 'title':
        comparator = (a, b) => a.title.compareTo(b.title);
        break;
      case 'price':
        comparator = (a, b) => (a.price ?? 0).compareTo(b.price ?? 0);
        break;
      case 'date':
        comparator = (a, b) => a.createdAt.compareTo(b.createdAt);
        break;
      default:
        return;
    }
    _courses.sort(ascending ? comparator : (a, b) => comparator(b, a));
    notifyListeners();
  }

  Future<void> loadMoreCourses() async {
    _setLoading(true);
    try {
      final moreCourses =
          await _courseService.getCoursesByPage(_currentPage + 1, _pageSize);
      if (moreCourses.isNotEmpty) {
        _courses.addAll(moreCourses);
        _currentPage++;
        notifyListeners();
      }
    } catch (e) {
      _setError(_handleException(e));
    }
    _setLoading(false);
  }

  List<CourseModel> searchCourses(String query) {
    if (query.isEmpty) return _courses;
    return _courses
        .where((course) =>
            course.title.toLowerCase().contains(query.toLowerCase()) ||
            course.description.toLowerCase().contains(query.toLowerCase()) ||
            course.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<CourseModel> getCoursesByTeacher(String teacherId) {
    return _courses.where((course) => course.teacherId == teacherId).toList();
  }

  // IMPORTANT : ajout du paramètre optionnel File? file pour upload
  Future<bool> createCourse(
    CourseModel course, {
    File? file,
    Uint8List? fileBytes,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      final newCourse = await _courseService.createCourse(
        course,
        file: file,
        fileBytes: fileBytes,
      );
      _courses.add(newCourse);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(_handleException(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateCourse(CourseModel course) async {
    _setLoading(true);
    try {
      await _courseService.updateCourse(course);
      final index = _courses.indexWhere((c) => c.id == course.id);
      if (index != -1) {
        _courses[index] = course;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(_handleException(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteCourse(String courseId) async {
    // String ici
    try {
      await _courseService.deleteCourse(courseId);
      _courses.removeWhere((course) => course.id == courseId);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(_handleException(e));
      return false;
    }
  }

  void toggleFavorite(String courseId) {
    // String ici
    if (_favorites.contains(courseId)) {
      _favorites.remove(courseId);
    } else {
      _favorites.add(courseId);
    }
    notifyListeners();
  }

  bool isFavorite(String courseId) => _favorites.contains(courseId); // String

  void purchaseCourse(String courseId) {
    // String ici
    final course = _courses.firstWhere((c) => c.id == courseId,
        orElse: () => throw Exception('Course not found'));
    _purchasedCourses.add(course);
    notifyListeners();
  }

  bool isPurchased(String courseId) =>
      _purchasedCourses.any((course) => course.id == courseId); // String

  void updateProgress(String courseId, double progress) {
    final courseIndex = _purchasedCourses.indexWhere((c) => c.id == courseId);
    if (courseIndex != -1) {
      _purchasedCourses[courseIndex].progress = progress;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  String _handleException(dynamic e) {
    if (e is AppException) return e.message;
    return 'Une erreur est survenue.';
  }
}
