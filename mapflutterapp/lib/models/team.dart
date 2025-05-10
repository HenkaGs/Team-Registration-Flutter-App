class Team {
  final String id;
  final String name;
  final String coach;
  final List<String> players;

  Team({
    required this.id,
    required this.name,
    required this.coach,
    required this.players,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      coach: json['coach'],
      players: List<String>.from(json['players']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coach': coach,
      'players': players,
    };
  }
}
