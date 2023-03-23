import 'package:equatable/equatable.dart';

class SignInEntity extends Equatable {
  final String email;
  final String passwd;

  const SignInEntity({required this.email, required this.passwd});
  
  @override
  List<Object?> get props => [email, passwd];
}
