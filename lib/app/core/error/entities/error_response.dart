import 'package:equatable/equatable.dart';

class ErrorResponse extends Equatable{
  final int code;
  final String type;
  final String message;

  const ErrorResponse({
    required this.code,
    required this.type,
    required this.message
  });

  @override
  List<Object?> get props => [code, type, message];
}
