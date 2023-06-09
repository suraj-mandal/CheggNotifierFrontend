class CheggProfile {
  final String username;
  final String password;

  CheggProfile({required this.username, required this.password});

  factory CheggProfile.fromJson(Map<String, dynamic> json) {
    return CheggProfile(username: json['username'], password: json['password']);
  }

  Map<String, String> toJson() {
    return {'username': username, 'password': password };
  }
}
