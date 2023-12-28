import 'package:authentication_flutter/app/services/http/http_service.dart';
import 'package:authentication_flutter/app/services/http/interceptors/my_http_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String baseUrl = "http://192.168.0.10/api-tokenization/api";

class DioHttpService extends HttpService {

  late Dio _dio;
  late bool _testIgnore;
  final MyHttpInterceptor _myHttpInterceptor = MyHttpInterceptor();

  DioHttpService(Dio dio, {bool testIgnore = false}) {
    _dio = dio;
    _dio.options = _options;
    _testIgnore = testIgnore;

    _dio.interceptors.clear();
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
    ));
    _dio.interceptors.addAll([InterceptorsWrapper(
      onRequest: (options, handler) async{
        await _myHttpInterceptor.onRequest(options);
        return handler.next(options);
      },
      onResponse: (response, handler) async{
        await _myHttpInterceptor.onResponse(response);
        return handler.next(response);
      },
      onError: (error, handler) async{
        if(_testIgnore) return handler.next(error);
        await _myHttpInterceptor.onError(error, (result){
          if(result != null){
            return handler.resolve(result);
          }else if(error.response != null){
            return handler.next(error);
          }
        });
      }
    )]);
  }

  @override
  Future<Response<T>> delete<T>(String url) async {
    return await _dio.delete(url);
  }

  @override
  Future<Response<T>> get<T>(String url) async {
    return await _dio.get(url);
  }

  @override
  Future<Response<T>> patch<T>(String url, {data}) async {
    return await _dio.patch(url, data: data);
  }

  @override
  Future<Response<T>> post<T>(String url, {data}) async {
    return await _dio.post(url, data: data);
  }

  @override
  Future<Response<T>> put<T>(String url, {data}) async {
    return await _dio.put(url, data: data);
  }

  BaseOptions get _options => BaseOptions(
    baseUrl: baseUrl,
    receiveDataWhenStatusError: true,
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
    followRedirects: false,
    headers: _defaultConfigHeader(),
    sendTimeout: const Duration(milliseconds: 5000),
    receiveTimeout: const Duration(milliseconds: 5000),
  );

  Map<String, dynamic> _defaultConfigHeader() {
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Cache-Control": "no-cache"
    };
  }
}
