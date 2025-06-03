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

factory UserModel.fromJson(Map<String, dynamic> json) {
  print('Full user JSON response: $json'); // Add this line
  print('Skin type data: ${json['user_skin_type']}'); // Check the exact key
  
  return UserModel(
    id: json['id'].toString(),
    name: json['name'],
    email: json['email'],
    userSkinType: json['user_skin_type'] != null
      ? UserSkinType.fromJson(json['user_skin_type'])
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
