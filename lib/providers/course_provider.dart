import 'package:flutter/material.dart';
import 'package:edustore/models/course_model.dart';
import 'package:edustore/services/course_service.dart';
import 'package:edustore/utils/app_exception.dart';

class CourseProvider with ChangeNotifier {
  final CourseService _courseService = CourseService();
  String _selectedCategory = 'Tous';
  String _selectedLevel = 'Tous';

  // Getters et setters pour les filtres
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

  // Méthode pour filtrer les cours
  List<CourseModel> get filteredCourses {
    return _courses.where((course) {
      if (_selectedCategory != 'Tous' && course.category != _selectedCategory) {
        return false;
      }
      if (_selectedLevel != 'Tous') {
        final levelText = _getLevelText(course.level);
        if (levelText != _selectedLevel) {
          return false;
        }
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

  List<CourseModel> _courses = [];
  final List<CourseModel> _purchasedCourses = [];
  final List<int> _favorites = [];

  bool _isLoading = false;
  String? _errorMessage;

  int _currentPage = 1;
  final int _pageSize = 10;

  List<CourseModel> get courses => _courses;
  List<CourseModel> get purchasedCourses => _purchasedCourses;
  List<int> get favorites => _favorites;
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

  /// Tri les cours par clé : 'title', 'price', 'date'
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

  /// Simule un chargement par page (pagination)
  Future<void> loadMoreCourses() async {
    _setLoading(true);
    try {
      final moreCourses =
          await _courseService.getCoursesByPage(_currentPage + 1, _pageSize);
      _courses.addAll(moreCourses);
      _currentPage++;
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

  List<CourseModel> getCoursesByTeacher(int teacherId) {
    return _courses.where((course) => course.teacherId == teacherId).toList();
  }

  Future<bool> createCourse(CourseModel course) async {
    _setLoading(true);
    try {
      final newCourse = await _courseService.createCourse(course);
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

  Future<bool> deleteCourse(int courseId) async {
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

  void toggleFavorite(int courseId) {
    if (_favorites.contains(courseId)) {
      _favorites.remove(courseId);
    } else {
      _favorites.add(courseId);
    }
    notifyListeners();
  }

  bool isFavorite(int courseId) => _favorites.contains(courseId);

  void purchaseCourse(int courseId) {
    final course = _courses.firstWhere((c) => c.id == courseId,
        orElse: () => throw Exception('Course not found'));
    _purchasedCourses.add(course);
    notifyListeners();
  }

  bool isPurchased(int courseId) =>
      _purchasedCourses.any((course) => course.id == courseId);

  void updateProgress(int courseId, double progress) {
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

  /// Gestion centralisée des erreurs avec AppException
  String _handleException(dynamic e) {
    if (e is AppException) return e.message;
    return 'Une erreur est survenue.';
  }
}
