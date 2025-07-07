enum CourseFormat { pdf, video }

enum CourseLevel { beginner, intermediate, advanced }

class CourseModel {
  final String id; // <- changé en String
  final String title;
  final String description;
  final double? price;
  final String currency;
  final CourseFormat format;
  final String teacher;
  final String teacherId;
  final String image;
  final int students;
  final double revenue;
  final double rating;
  final String duration;
  final int lessons;
  final String category;
  final CourseLevel level;
  final DateTime createdAt;
  final bool isPublished;
  double progress;
  bool isFavorite;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    this.price,
    required this.currency,
    required this.format,
    required this.teacher,
    required this.teacherId,
    required this.image,
    required this.students,
    required this.revenue,
    required this.rating,
    required this.duration,
    required this.lessons,
    required this.category,
    required this.level,
    required this.createdAt,
    required this.isPublished,
    this.progress = 0.0,
    this.isFavorite = false,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id']?.toString() ?? '', // id en string
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toDouble(),
      currency: json['currency'] ?? 'XAF',
      format: json['format'] == 'video' ? CourseFormat.video : CourseFormat.pdf,
      teacher: json['teacher'] ?? json['instructor'] ?? '',
      teacherId: json['teacherId']?.toString() ?? '',
      image: json['image'] ?? 'https://via.placeholder.com/300x200',
      students: json['students'] ?? 0,
      revenue: (json['revenue'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      duration: json['duration'] ?? '',
      lessons: json['lessons'] ?? 0,
      category: json['category'] ?? '',
      level: _parseCourseLevel(json['level'] ?? 'beginner'),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isPublished: json['isPublished'] ?? true,
      progress: (json['progress'] ?? 0).toDouble(),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  static CourseLevel _parseCourseLevel(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
      case 'débutant':
        return CourseLevel.beginner;
      case 'intermediate':
      case 'intermédiaire':
        return CourseLevel.intermediate;
      case 'advanced':
      case 'avancé':
        return CourseLevel.advanced;
      default:
        return CourseLevel.beginner;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'currency': currency,
      'format': format == CourseFormat.video ? 'video' : 'pdf',
      'teacher': teacher,
      'instructor': teacher,
      'teacherId': teacherId,
      'image': image,
      'students': students,
      'revenue': revenue,
      'rating': rating,
      'duration': duration,
      'lessons': lessons,
      'category': category,
      'level': level.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'isPublished': isPublished,
      'progress': progress,
      'isFavorite': isFavorite,
    };
  }

  bool get isFree => price == null || price == 0;

  String get priceDisplay => isFree ? 'GRATUIT' : '${price!.toInt()} $currency';

  String get instructor => teacher;

  String get levelText {
    switch (level) {
      case CourseLevel.beginner:
        return 'Débutant';
      case CourseLevel.intermediate:
        return 'Intermédiaire';
      case CourseLevel.advanced:
        return 'Avancé';
    }
  }

  String get formatText {
    switch (format) {
      case CourseFormat.pdf:
        return 'PDF';
      case CourseFormat.video:
        return 'Vidéo';
    }
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? currency,
    CourseFormat? format,
    String? teacher,
    String? teacherId,
    String? image,
    int? students,
    double? revenue,
    double? rating,
    String? duration,
    int? lessons,
    String? category,
    CourseLevel? level,
    DateTime? createdAt,
    bool? isPublished,
    double? progress,
    bool? isFavorite,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      format: format ?? this.format,
      teacher: teacher ?? this.teacher,
      teacherId: teacherId ?? this.teacherId,
      image: image ?? this.image,
      students: students ?? this.students,
      revenue: revenue ?? this.revenue,
      rating: rating ?? this.rating,
      duration: duration ?? this.duration,
      lessons: lessons ?? this.lessons,
      category: category ?? this.category,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      isPublished: isPublished ?? this.isPublished,
      progress: progress ?? this.progress,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  bool get isAccessible => isPublished && (isFree || progress > 0);

  String get statusText {
    if (!isPublished) return 'Brouillon';
    if (isFree) return 'Gratuit';
    return 'Payant';
  }

  String get formattedDuration =>
      duration.isEmpty ? 'Durée non spécifiée' : duration;

  String get studentsText {
    if (students == 0) return 'Aucun étudiant';
    if (students == 1) return '1 étudiant';
    return '$students étudiants';
  }

  String get ratingText {
    if (rating == 0) return 'Pas encore noté';
    return '${rating.toStringAsFixed(1)}/5';
  }

  @override
  String toString() =>
      'CourseModel(id: $id, title: $title, price: $price, isFree: $isFree)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CourseModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
