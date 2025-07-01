import 'package:flutter/material.dart';
import 'package:edustore/models/course_model.dart';

class CartItem {
  final CourseModel course;
  final DateTime addedAt;

  CartItem({
    required this.course,
    required this.addedAt,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.length;
  double get totalAmount =>
      _items.fold(0.0, (sum, item) => sum + (item.course.price ?? 0.0));

  void addToCart(CourseModel course) {
    if (!_items.any((item) => item.course.id == course.id)) {
      _items.add(CartItem(
        course: course,
        addedAt: DateTime.now(),
      ));
      notifyListeners();
    }
  }

  void removeFromCart(int courseId) {
    _items.removeWhere((item) => item.course.id == courseId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(int courseId) {
    return _items.any((item) => item.course.id == courseId);
  }
}
