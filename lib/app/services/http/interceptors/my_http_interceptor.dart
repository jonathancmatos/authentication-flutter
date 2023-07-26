import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/regenerate_access_token.dart';
import 'package:authentication_flutter/app/services/http/http_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MyHttpInterceptor extends MyInterceptor<dynamic, dynamic, dynamic> {
 
  @override
  Future onRequest(dynamic request) async{
    if (_getAccessToken.isNotEmpty){
      request.headers["Authorization"] = "Bearer $_getAccessToken";
    }

    return request;
  }

  @override
  Future onResponse(dynamic response) async {
    return response;
  }

  @override
  Future onError(error, {Function(dynamic options)? retry}) async{
    if(error.response != null && error.response.data != null){
      Map failure = error.response.data["response"];
      if(failure.containsKey("type") && failure["type"] == "token_expired"){

        if(!await _generateAccessToken()) return;
      
        error.requestOptions.headers['Authorization'] = "Bearer $_getAccessToken";
        await retry!(error.requestOptions);
      }
    }
    return error;
  }

  Future<bool> _generateAccessToken() async{
    final result = await Modular.get<RegenerateAccessTokenImpl>().call();
    if(result!.isLeft()){
      await Modular.get<UserManagerStore>().logoff(isExpiredToken: true);
      return false;
    }
    return true;
  }

  String get _getAccessToken => Modular.get<SessionManager>().getAccessToken() ?? '';
  
}
