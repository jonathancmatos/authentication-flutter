import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/features/auth/data/datasources/auth_datasource.dart';
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../../fixtures/fixture_reader.dart';
import '../../mocks/auth_mock.mocks.dart';

void main() {
  late MockDioHttpService mockHttpService;
  late AuthDataSourceImpl authDataSource;

  setUp(() {
    mockHttpService = MockDioHttpService();
    authDataSource = AuthDataSourceImpl(mockHttpService);
  });

  group("signUp", () {
    const model = AccountModel(
        name: "Jonathan Costa",
        email: "contato@devjonathan.com",
        passwd: "12345678",
        phone: "88996770054");

    test('should return true when registering a new user ', () async {
      //arrange
      final response = fixture("authetication/created_account_success.json");
      when(mockHttpService.post(any, data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: response,
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));
      //act
      final result = await authDataSource.signUp(model);
      //assert
      expect(result, true);
    });

    test('should return Server Exception when registering a new user ',
        () async {
      //arrange
      final response = fixture("authetication/created_account_error.json");
      when(mockHttpService.post(any, data: anyNamed('data'))).thenThrow(
        DioError(
          requestOptions: RequestOptions(),
          response: Response(
            data: response,
            statusCode: 400,
            requestOptions: RequestOptions(),
          ),
        ),
      );
      //act
      final call = authDataSource.signUp;
      //assert
      expect(() async => await call(model),throwsA(isA<ServerException>()));
    });
  });
}
