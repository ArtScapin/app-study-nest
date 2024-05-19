class Course {
  final int id;
  final String name;
  final String description;
  final String thumbnail;
  final bool visibility;
  final String createdAt;
  final User user;
  final List<Lesson> lessons;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.visibility,
    required this.createdAt,
    required this.user,
    required this.lessons,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    var lessonsFromJson = json['lessons'] as List?;
    List<Lesson> lessonsList = lessonsFromJson != null
        ? lessonsFromJson.map((i) => Lesson.fromJson(i)).toList()
        : [];

    return Course(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      visibility: json['visibility'],
      createdAt: json['createdAt'],
      user: User.fromJson(json['user']),
      lessons: lessonsList,
    );
  }
}

class User {
  final int id;
  final String username;
  final String email;
  final String createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      createdAt: json['createdAt'],
    );
  }
}

class Lesson {
  final int id;
  final String name;
  final String description;
  final String video;
  final int order;

  Lesson({
    required this.id,
    required this.name,
    required this.description,
    required this.video,
    required this.order,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      video: json['video'],
      order: json['order'],
    );
  }
}
