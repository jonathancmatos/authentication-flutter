import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{

  final String name;
  final String email;
  final String phone;
  final String? googleId;

  const UserEntity({
    required this.name, 
    required this.email, 
    required this.phone,
    this.googleId
  });
  
  @override
  List<Object?> get props => [name, email, phone];

}
