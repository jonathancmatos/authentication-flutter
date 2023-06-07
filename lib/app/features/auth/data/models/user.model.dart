import 'package:authentication_flutter/app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity{

  const UserModel({
    required String name, 
    required String email, 
    required String phone
  }):super(name: name, email: email, phone: phone);

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "name":name,
      "email":email,
      "phone":phone
    };
  }

  @override
  String toString() {
    return "{UserModel:name:$name, email:$email, phone:$phone}";
  }
}