class AuthDetails {
  final String email;
  final String password;
  final String userName;

  AuthDetails({
    required this.email,
    required this.password,
    required this.userName,
  });

  factory AuthDetails.fromJson(Map<String, dynamic> json) {
    return AuthDetails(
      email: json['email'],
      password: json['password'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'userName': userName,
    };
  }
}
