import 'package:authentication_flutter/app/features/auth/domain/entities/user_entity.dart';


class NewAccountEntity extends UserEntity {

  final String passwd;

  const NewAccountEntity({
    required String name, 
    required String email, 
    required String phone,
    required this.passwd,
  }) : super(name: name, email: email, phone: phone);

}
