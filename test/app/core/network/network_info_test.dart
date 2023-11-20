import 'package:authentication_flutter/app/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnectionChecker extends Mock implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  test('should forward the call to InternetConnectionChecker.hasConnection',
      () async {
    //arrange
    final hasConnectionFuture = Future.value(true);
    when(() => mockInternetConnectionChecker.hasConnection)
        .thenAnswer((_) async => await hasConnectionFuture);
    //act
    final result = await networkInfo.isConnected;
    //assert
    verify(() => mockInternetConnectionChecker.hasConnection);
    expect(result, equals(true));
  });
}
