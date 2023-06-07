// Mocks generated by Mockito 5.4.0 from annotations
// in authentication_flutter/test/app/features/auth/mocks/auth_mock.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:authentication_flutter/app/core/error/failure.dart' as _i7;
import 'package:authentication_flutter/app/core/network/network_info.dart'
    as _i13;
import 'package:authentication_flutter/app/features/auth/data/datasources/auth_datasource.dart'
    as _i10;
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart'
    as _i11;
import 'package:authentication_flutter/app/features/auth/data/models/sign_in_model.dart'
    as _i12;
import 'package:authentication_flutter/app/features/auth/domain/entities/new_account_entity.dart'
    as _i8;
import 'package:authentication_flutter/app/features/auth/domain/entities/sign_in_entity.dart'
    as _i9;
import 'package:authentication_flutter/app/features/auth/domain/repositories/auth_repository.dart'
    as _i5;
import 'package:authentication_flutter/app/services/http/dio_http_service.dart'
    as _i3;
import 'package:dio/dio.dart' as _i2;
import 'package:fpdart/fpdart.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDio_0 extends _i1.SmartFake implements _i2.Dio {
  _FakeDio_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeResponse_1<T> extends _i1.SmartFake implements _i2.Response<T> {
  _FakeResponse_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [DioHttpService].
///
/// See the documentation for Mockito's code generation for more information.
class MockDioHttpService extends _i1.Mock implements _i3.DioHttpService {
  @override
  _i2.Dio get dio => (super.noSuchMethod(
        Invocation.getter(#dio),
        returnValue: _FakeDio_0(
          this,
          Invocation.getter(#dio),
        ),
        returnValueForMissingStub: _FakeDio_0(
          this,
          Invocation.getter(#dio),
        ),
      ) as _i2.Dio);
  @override
  _i4.Future<_i2.Response<T>> delete<T>(
    String? url, {
    dynamic data,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [url],
          {#data: data},
        ),
        returnValue: _i4.Future<_i2.Response<T>>.value(_FakeResponse_1<T>(
          this,
          Invocation.method(
            #delete,
            [url],
            {#data: data},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Response<T>>.value(_FakeResponse_1<T>(
          this,
          Invocation.method(
            #delete,
            [url],
            {#data: data},
          ),
        )),
      ) as _i4.Future<_i2.Response<T>>);
  @override
  _i4.Future<_i2.Response<T>> get<T>(String? url) => (super.noSuchMethod(
        Invocation.method(
          #get,
          [url],
        ),
        returnValue: _i4.Future<_i2.Response<T>>.value(_FakeResponse_1<T>(
          this,
          Invocation.method(
            #get,
            [url],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Response<T>>.value(_FakeResponse_1<T>(
          this,
          Invocation.method(
            #get,
            [url],
          ),
        )),
      ) as _i4.Future<_i2.Response<T>>);
  @override
  _i4.Future<_i2.Response<T>> patch<T>(
    String? url, {
    dynamic data,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #patch,
          [url],
          {#data: data},
        ),
        returnValue: _i4.Future<_i2.Response<T>>.value(_FakeResponse_1<T>(
          this,
          Invocation.method(
            #patch,
            [url],
            {#data: data},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Response<T>>.value(_FakeResponse_1<T>(
          this,
          Invocation.method(
            #patch,
            [url],
            {#data: data},
          ),
        )),
      ) as _i4.Future<_i2.Response<T>>);
  @override
  _i4.Future<_i2.Response<T>> post<T>(
    String? url, {
    dynamic data,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [url],
          {#data: data},
        ),
        returnValue: _i4.Future<_i2.Response<T>>.value(_FakeResponse_1<T>(
          this,
          Invocation.method(
            #post,
            [url],
            {#data: data},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Response<T>>.value(_FakeResponse_1<T>(
          this,
          Invocation.method(
            #post,
            [url],
            {#data: data},
          ),
        )),
      ) as _i4.Future<_i2.Response<T>>);
  @override
  _i4.Future<_i2.Response<T>> put<T>(
    String? url, {
    dynamic data,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #put,
          [url],
          {#data: data},
        ),
        returnValue: _i4.Future<_i2.Response<T>>.value(_FakeResponse_1<T>(
          this,
          Invocation.method(
            #put,
            [url],
            {#data: data},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Response<T>>.value(_FakeResponse_1<T>(
          this,
          Invocation.method(
            #put,
            [url],
            {#data: data},
          ),
        )),
      ) as _i4.Future<_i2.Response<T>>);
}

/// A class which mocks [AuthRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthRepository extends _i1.Mock implements _i5.AuthRepository {
  MockAuthRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i6.Either<_i7.Failure, bool>>? signUp(
          _i8.NewAccountEntity? account) =>
      (super.noSuchMethod(Invocation.method(
        #signUp,
        [account],
      )) as _i4.Future<_i6.Either<_i7.Failure, bool>>?);
  @override
  _i4.Future<_i6.Either<_i7.Failure, bool>>? signIn(_i9.SignInEntity? signIn) =>
      (super.noSuchMethod(Invocation.method(
        #signIn,
        [signIn],
      )) as _i4.Future<_i6.Either<_i7.Failure, bool>>?);
}

/// A class which mocks [AuthDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthDataSource extends _i1.Mock implements _i10.AuthDataSource {
  MockAuthDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool>? signUp(_i11.AccountModel? model) =>
      (super.noSuchMethod(Invocation.method(
        #signUp,
        [model],
      )) as _i4.Future<bool>?);
  @override
  _i4.Future<Map<String, dynamic>>? signIn(_i12.SignInModel? model) =>
      (super.noSuchMethod(Invocation.method(
        #signIn,
        [model],
      )) as _i4.Future<Map<String, dynamic>>?);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i13.NetworkInfo {
  MockNetworkInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> get isConnected => (super.noSuchMethod(
        Invocation.getter(#isConnected),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}
