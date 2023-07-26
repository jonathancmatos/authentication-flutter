import 'dart:convert';
import 'package:authentication_flutter/app/features/auth/data/models/token_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../../fixtures/fixture_reader.dart';

void main() {
  Map<String, dynamic> jsonMock = {};

  setUpAll(() async{
    jsonMock = await json.decode(fixture("authetication/login_success.json"));
  });

  test('should return an object of type tokenModel', (){
    //act
    final model = TokenModel.fromJson(jsonMock);
    //assert
    expect(model, equals(isA<TokenModel>()));
    expect(model.accessToken, equals(jsonMock["access_token"]));
    expect(model.refreshToken, equals(jsonMock["refresh_token"]));
  });

  test('should return a map of type [TokenModel]', (){
    //act
    const model = TokenModel(
      accessToken: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2Nzk1MzkwMzcsIm5iZiI6MTY3OTUzOTAzNywiaXNzIjoibG9jYWxob3N0IiwidXNlcm5hbWUiOiJ0b2tlbml6YXRpb24iLCJleHAiOjE2Nzk1Mzk5MzcsImVtYWlsIjoiam9uYXRoYW5jb3N0YUBnbWFpbC5jb20ifQ.A9HqTVEqSbvlZaTlJaqvEIUcih65aMVHwxItC2-NuuKH_GI5epZlXBG7Y6sCxAZcbNPMYbUeAwKx7HEpm3cD3A", 
      refreshToken: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2Nzk1MzkwMzcsIm5iZiI6MTY3OTUzOTAzNywiaXNzIjoibG9jYWxob3N0IiwidXNlcm5hbWUiOiJ0b2tlbml6YXRpb24iLCJleHAiOjE2Nzk2MjU0MzcsImVtYWlsIjoiam9uYXRoYW5jb3N0YUBnbWFpbC5jb20ifQ.iukAsv3zpg1g66SPvptBEZGvXVJYBdK8hli1SkLnx3h0iyQ4xoqyNh_gvxRRhXNsPHiIF9O_vFTAt8tNDGLgrg"
    );
    //assert
    expect(model.toJson(), equals(isA<Map>()));
    expect(model.toJson(), equals(jsonMock));
  });
  
}