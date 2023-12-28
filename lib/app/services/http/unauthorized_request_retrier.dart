import 'package:authentication_flutter/app/services/http/http_service.dart';

abstract class UnauthorizedRequestRetrier<TResponse>{
  Future<TResponse> retry({required dynamic options});
}

class UnauthorizedRequestRetrierImpl implements UnauthorizedRequestRetrier{

  final HttpService _httpService;
  UnauthorizedRequestRetrierImpl(this._httpService);

  @override
  Future retry({
    required options, 
    int attemps = 3, 
    Duration retryDelay = const Duration(seconds: 3),
    Function(Object e)? retryIf
  }) async{

    int retryAttemps = 0;
    late Object exception;

    while(retryAttemps < attemps){
      try{
        switch(options.method.toString().toLowerCase()){
          case "post":
            return await _httpService.post(options.path, data: options.data);
          case "get":
            return await _httpService.get(options.path);
          case "put":
            return await _httpService.put(options.path, data: options.data);
          case "delete":
            return await _httpService.delete(options.path);
          case "patch":
            return await _httpService.patch(options.path, data: options.data);
          default:
            return throw(Exception('Invalid request method.'));        
        }
      }catch(e){
        exception = e;
        if(retryIf == null || !retryIf(e)){
          rethrow;
        }
      }
      retryAttemps++;
      await Future.delayed(retryDelay);
    }
    throw exception;
  }
}