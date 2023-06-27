
const String baseUrl = "http://192.168.0.5/api-tokenization/api";

abstract class HttpService {
  Future<dynamic> get<T>(String? url);
  Future<dynamic> post<T>(String? url, {dynamic data});
  Future<dynamic> put<T>(String? url, {dynamic data});
  Future<dynamic> patch<T>(String? url, {dynamic data});
  Future<dynamic> delete<T>(String? url, {dynamic data});
}

abstract class MyInterceptor<TRequest, TResponse, TError> {
  Future<TRequest> onRequest(TRequest request);
  Future<TResponse> onResponse(TResponse response);
  Future<TError> onError(TError error);
}
