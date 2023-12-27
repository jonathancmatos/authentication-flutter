import 'dart:async';

import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class GoogleAuth{
  FutureOr<dynamic> signIn();
  Future<bool> logout();
}

class GoogleAuthImpl implements GoogleAuth{

  final GoogleSignIn _googleSignIn;
  GoogleAuthImpl(this._googleSignIn);

  @override
  Future<bool> logout() async{
    try{
      
      final result = await _googleSignIn.disconnect();
      return result == null;

    }catch(e){
      throw const ServerException(
        message: 'Não foi possível sair da sua conta. Por favor, tente novamente.'
      );
    }
  }

  @override
  FutureOr signIn() async{
    try{

      GoogleSignInAccount? result = await _googleSignIn.signIn();
      
      if(result == null){
        return throw('Usuário não encontrado.');
      }

      return result;

    }catch(e){
      throw const ServerException(
        message: 'Não foi possível realizar o login com o Google. Por favor, tente novamente.'
      );
    }
  }

}