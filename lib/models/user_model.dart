import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { teacher, student }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? profileImage;
  final DateTime joinDate;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
    required this.joinDate,
  });

  /// 🔄 Création depuis Firestore (DocumentSnapshot)
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: _parseRole(data['role']),
      profileImage: data['profileImage'],
      joinDate: (data['joinDate'] != null)
          ? (data['joinDate'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// 🔼 Conversion vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role.name,
      'profileImage': profileImage,
      'joinDate': Timestamp.fromDate(joinDate),
    };
  }

  /// 🔄 Création depuis JSON (ex : API REST)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: _parseRole(json['role']),
      profileImage: json['profileImage'],
      joinDate: json['joinDate'] is String
          ? DateTime.tryParse(json['joinDate']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// 🔼 Vers JSON (ex : pour export local)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'profileImage': profileImage,
      'joinDate': joinDate.toIso8601String(),
    };
  }

  /// 🔁 Parse dynamique (string → UserRole)
  static UserRole _parseRole(dynamic role) {
    switch (role.toString().toLowerCase()) {
      case 'teacher':
        return UserRole.teacher;
      case 'student':
      default:
        return UserRole.student;
    }
  }

  /// Pour affichage UI : 'Enseignant' ou 'Étudiant'
  String get roleLabel {
    switch (role) {
      case UserRole.teacher:
        return 'Enseignant';
      case UserRole.student:
        return 'Étudiant';
    }
  }
}
