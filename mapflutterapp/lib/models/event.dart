class Event {
  final String id;
  final String name;
  final DateTime date;
  final String location;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'location': location,
    };
  }
}
