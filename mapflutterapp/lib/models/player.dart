class Player {
  final String id;
  final String name;
  final int age;
  final String position;

  Player({
    required this.id,
    required this.name,
    required this.age,
    required this.position,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'position': position,
    };
  }
}
