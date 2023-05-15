import 'package:authentication_flutter/app/services/http/http_service.dart';

class MyHttpInterceptor extends MyInterceptor<dynamic, dynamic, dynamic>{

  @override
  Future onError(dynamic error) async{
    // TODO: implement onError
    return error;
  }

  @override
  Future onRequest(dynamic request) async{
    // TODO: implement onRequest
    return request;
  }

  @override
  Future onResponse(dynamic response) async{
    // TODO: implement onResponse
    return response;
  }
  
  

}