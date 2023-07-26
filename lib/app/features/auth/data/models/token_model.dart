import 'package:authentication_flutter/app/features/auth/domain/entities/token_entity.dart';

class TokenModel extends TokenEntity{
  
  const TokenModel({
    required String accessToken, 
    required String refreshToken
  }):super(accessToken: accessToken, refreshToken: refreshToken);

  factory TokenModel.fromJson(Map<String, dynamic> json){
    return TokenModel(
      accessToken: json["access_token"] ?? "", 
      refreshToken: json["refresh_token"] ?? ""
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "access_token":accessToken,
      "refresh_token":refreshToken
    };
  }

  @override
  String toString() {
    return "{TokenModel: access_token=$accessToken,  refresh_token=$refreshToken}";
  }

}