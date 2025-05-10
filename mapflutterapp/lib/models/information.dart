class Information {
  final String id;
  final String title;
  final String content;
  final DateTime timestamp;

  Information({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  factory Information.fromJson(Map<String, dynamic> json) {
    return Information(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
