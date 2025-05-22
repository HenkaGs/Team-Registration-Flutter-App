class Team {
  final String id;
  final String name;
  final String coach;
  final List<String> players;
  final String userId; // ID of the user who created the team
  final String contactName;
  final String contactEmail;
  final String contactPhone;

  Team({
    required this.id,
    required this.name,
    required this.coach,
    required this.players,
    required this.userId,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      coach: json['coach'],
      players: List<String>.from(json['players']),
      userId: json['userId'],
      contactName: json['contactName'],
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coach': coach,
      'players': players,
      'userId': userId,
      'contactName': contactName,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
    };
  }

  Team copyWith({
    String? id,
    String? name,
    String? coach,
    List<String>? players,
    String? userId,
    String? contactName,
    String? contactEmail,
    String? contactPhone,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      coach: coach ?? this.coach,
      players: players ?? this.players,
      userId: userId ?? this.userId,
      contactName: contactName ?? this.contactName,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
    );
  }
}
