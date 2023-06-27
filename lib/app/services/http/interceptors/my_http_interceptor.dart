import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:authentication_flutter/app/services/http/http_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MyHttpInterceptor extends MyInterceptor<dynamic, dynamic, dynamic> {
  @override
  Future onError(dynamic error) async {
    return error;
  }

  @override
  Future onRequest(dynamic request) async {
    final session = Modular.get<SessionManager>();
    String? accessToken = session.getAccessToken();
    
    if (accessToken != null && accessToken.isNotEmpty) {
      String token = session.getAccessToken() ?? "";
      request.headers["Authorization"] = "Bearer $token";
    }
    return request;
  }

  @override
  Future onResponse(dynamic response) async {
    return response;
  }
}
