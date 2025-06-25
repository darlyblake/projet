enum UserRole { teacher, student }

class UserModel {
  final int id;
  final String name;
  final String email;
  final UserRole role;
  final String? avatar;
  final DateTime joinDate;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    required this.joinDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'] == 'teacher' ? UserRole.teacher : UserRole.student,
      avatar: json['avatar'],
      joinDate: DateTime.parse(json['joinDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role == UserRole.teacher ? 'teacher' : 'student',
      'avatar': avatar,
      'joinDate': joinDate.toIso8601String(),
    };
  }
}
