import 'package:equatable/equatable.dart';

class NewAccountEntity extends Equatable {
  final String name;
  final String email;
  final String passwd;
  final String phone;

  const NewAccountEntity({
    required this.name, 
    required this.passwd,
    required this.email, 
    required this.phone,
  });

  @override
  List<Object?> get props => [name, email, passwd, phone];
}
