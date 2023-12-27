import 'package:authentication_flutter/app/services/http/http_service.dart';

abstract class UnauthorizedRequestRetrier<TResponse>{
  Future<TResponse> retry({required dynamic options});
}

class UnauthorizedRequestRetrierImpl implements UnauthorizedRequestRetrier{

  final HttpService httpService;
  UnauthorizedRequestRetrierImpl(this.httpService);

  @override
  Future retry({required options}) async{
    switch(options.method.toString().toLowerCase()){
      case "post":
        return await httpService.post(options.path, data: options.data);
      case "get":
        return await httpService.get(options.path);
      case "put":
        return await httpService.put(options.path, data: options.data);
      case "delete":
        return await httpService.delete(options.path);
      case "patch":
        return await httpService.patch(options.path, data: options.data);
      default:
        return throw(Exception('Invalid request method.'));        
    }
  }
}