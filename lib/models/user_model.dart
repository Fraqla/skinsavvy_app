import 'package:skinsavvy_app/models/user_skin_type_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserSkinType? skinType;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.skinType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('User JSON: $json');

    return UserModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      skinType: json['skinType'] != null
        ? UserSkinType.fromJson(json['skinType']) 
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'skin_type': skinType?.toJson(),
    };
  }
  
}
