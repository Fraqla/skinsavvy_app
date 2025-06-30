import 'package:skinsavvy_app/models/user_skin_type_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserSkinType? userSkinType;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userSkinType,
  });

  // Add this copyWith method
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserSkinType? userSkinType,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      userSkinType: userSkinType ?? this.userSkinType,
    );
  }

factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'].toString(),
    name: json['name'],
    email: json['email'],
    userSkinType: json['skin_type'] != null 
        ? UserSkinType.fromJson(json['skin_type'])
        : null,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'skin_type': userSkinType?.toJson(),
    };
  }
}