import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]) : super();
}

class ServerFailure extends Failure {
  final String type;
  final String message;

  const ServerFailure({
    required this.type,
    required this.message,
  });

  @override
  List<Object?> get props => [type, message];
}

class InternalFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class NoConnectionFailure extends Failure {
  @override
  List<Object?> get props => [];
}
