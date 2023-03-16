import 'package:dio/dio.dart';

const String baseUrl = "http://192.168.0.6/api-tokenization/api";

abstract class HttpService {
  Future<Response<T>> get<T>(String? url);
  Future<Response<T>> post<T>(String? url, {dynamic data});
  Future<Response<T>> put<T>(String? url, {dynamic data});
  Future<Response<T>> patch<T>(String? url, {dynamic data});
  Future<Response<T>> delete<T>(String? url, {dynamic data});
}

abstract class MyInterceptor<TRequest, TResponse, TError> {
  Future<TRequest> onRequest(TRequest request);
  Future<TResponse> onResponse(TResponse response);
  Future<TError> onError(TError error);
}
