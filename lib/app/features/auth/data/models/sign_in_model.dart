import 'package:authentication_flutter/app/features/auth/domain/entities/sign_in_entity.dart';

class SignInModel extends SignInEntity {

  const SignInModel({
    required String email,
    required String passwd,
  }) : super(email: email, passwd: passwd);


  Map<String, dynamic> toJson(){
    return {
      "email":email,
      "passwd":passwd
    };
  }

  @override
  String toString() {
    return "{SignInModel: email:$email, passwd:$passwd}";
  }
}
