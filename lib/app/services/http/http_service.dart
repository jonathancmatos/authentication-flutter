
abstract class HttpService {
  Future<dynamic> get<T>(String url);
  Future<dynamic> post<T>(String url, {dynamic data});
  Future<dynamic> put<T>(String url, {dynamic data});
  Future<dynamic> patch<T>(String url, {dynamic data});
  Future<dynamic> delete<T>(String url);
}

abstract class MyInterceptor<TRequest, TResponse, TError> {
  Future<TRequest> onRequest(TRequest request);
  Future<TResponse> onResponse(TResponse response);
  Future<TError> onError(TError error, Function(dynamic result)? onResolver);
}
