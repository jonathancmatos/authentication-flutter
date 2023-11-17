import 'package:authentication_flutter/app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity{

  const UserModel({
    required String name, 
    required String email, 
    required String phone,
    String? googleId
  }):super(name: name, email: email, phone: phone, googleId: googleId);

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      googleId: json['id_google']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "name":name,
      "email":email,
      "phone":phone,
      "google_id":googleId
    };
  }

  @override
  String toString() {
    return "{UserModel:name:$name, email:$email, phone:$phone, google_id:$googleId}";
  }
}