class Task {
  final int id;
  final String title;
  bool completed;
  bool dbData;

  Task(
      {required this.id,
      required this.title,
      this.completed = false,
      this.dbData = false});

  // Creates a Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      completed: json['completed'] ?? false,
      dbData: json['dbData'] ?? false,
    );
  }

  // Converts JSON list to Task list
  static List<Task> listFromJson(List<dynamic> data) =>
      List.from(data.map((e) => Task.fromJson(e)));
}
