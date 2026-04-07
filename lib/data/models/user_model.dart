class UserModel {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String token;
  
  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    required this.token,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? json['username'] ?? 'User',
      avatar: json['avatar'],
      token: json['token'] ?? 'mock_token_12345',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'token': token,
    };
  }
}