import 'package:authentication_flutter/app/features/auth/domain/entities/new_account_entity.dart';
import 'package:authentication_flutter/app/utils/utils.dart';

class AccountModel extends NewAccountEntity {

  const AccountModel({
    required String name,
    required String email,
    required String passwd,
    required String phone,
  }) : super(
    name: name,
    email: email,
    passwd: passwd,
    phone: phone,
  );

  Map<String, dynamic> toJson() {
    return {
      "name":name,
      "email":email,
      "passwd": passwd,
      "phone": leaveOnlyNumber(phone)
    };
  }

  @override
  String toString() {
    return "name:$name, email:$email, phone:$phone";
  }

}
