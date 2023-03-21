import 'package:authentication_flutter/app/core/domain/entities/message.dart';
import 'package:authentication_flutter/app/core/error/failure.dart';

String leaveOnlyNumber(String value) {
  return value.replaceAll(RegExp(r'[^\d]'), '');
}

Message failureInExeptionConverted(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return Message(title: (failure as ServerFailure).type, text:failure.message);
    case NoConnectionFailure:
      return const Message(
          title: "No Connection", text: "Sem Conexão com internet");
    case InternalFailure:
      return const Message(
          title: "Internal Error",
          text: "Houve um erro ao tentar realizar essa operação.");
    default:
      return const Message(title: "Oops!", text: "Algo deu errado.");
  }
}
