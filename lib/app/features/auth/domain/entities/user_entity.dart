import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{

  final String name;
  final String email;
  final String phone;

  const UserEntity({
    required this.name, 
    required this.email, 
    required this.phone,
  });
  
  @override
  List<Object?> get props => [name, email, phone];

}
