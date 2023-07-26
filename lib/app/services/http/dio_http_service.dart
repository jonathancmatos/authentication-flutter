import 'package:authentication_flutter/app/services/http/http_service.dart';
import 'package:authentication_flutter/app/services/http/interceptors/my_http_interceptor.dart';
import 'package:dio/dio.dart';

class DioHttpService extends HttpService {

  final Dio _dio;

  DioHttpService(this._dio) {
    final interceptors = InterceptorsWrapper(
      onRequest: (options, handler) async{
        await MyHttpInterceptor().onRequest(options);
        return handler.next(options);
      },
      onResponse: (response, handler) async{
        await MyHttpInterceptor().onResponse(response);
        return handler.next(response);
      },
      onError: (error, handler) async{
        bool errorAlreadySolved = false;
        await MyHttpInterceptor().onError(error, retry: (options) async{
          final retryResponse = await _dio.request(
            options.path,
            data: options.data,
            options: Options(
              method: options.method,
              headers: options.headers,
            )
          );
          errorAlreadySolved = true;
          return handler.resolve(retryResponse);
        });

        if(!errorAlreadySolved) {
          return handler.next(error);
        }
      }
    );

    _dio.interceptors.add(interceptors);
  }

  Dio get dio => _dio;

  @override
  Future<Response<T>> delete<T>(String? url, {data}) async {
    return await _dio.delete(url ?? "", options: _getOptionsParams());
  }

  @override
  Future<Response<T>> get<T>(String? url) async {
    return await _dio.get(url ?? "", options: _getOptionsParams());
  }

  @override
  Future<Response<T>> patch<T>(String? url, {data}) async {
    return await _dio.patch(url ?? "", data: data, options: _getOptionsParams());
  }

  @override
  Future<Response<T>> post<T>(String? url, {data}) async {
    return await _dio.post(url ?? "", data: data, options: _getOptionsParams());
  }

  @override
  Future<Response<T>> put<T>(String? url, {data}) async {
    return await _dio.put(url ?? "", data: data, options: _getOptionsParams());
  }


  Options _getOptionsParams() {
    return Options(
      headers: _defaultConfigHeader(),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      followRedirects: false,
      sendTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 5000),
    );
  }

  Map<String, dynamic> _defaultConfigHeader() {
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Cache-Control": "no-cache"
    };
  }
}
