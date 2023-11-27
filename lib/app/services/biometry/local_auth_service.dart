import 'package:authentication_flutter/app/services/biometry/biometry_service.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class LocalAuthService extends BiometryService{

  final LocalAuthentication localAuthentication;
  LocalAuthService(this.localAuthentication);

  @override
  Future<bool> checkBiometricsActivated() async{
    final List<BiometricType> availableBiometrics = await localAuthentication.getAvailableBiometrics();
    if(availableBiometrics.isEmpty) return false;
    
    return availableBiometrics.contains(BiometricType.fingerprint)
      || availableBiometrics.contains(BiometricType.strong)
      || availableBiometrics.contains(BiometricType.weak);
  }

  @override
  Future<bool> isSupportBiometry() async{
    final bool canAuthenticateWithBiometrics = await localAuthentication.canCheckBiometrics;
    final bool isDeviceSupported = await localAuthentication.isDeviceSupported();
    return canAuthenticateWithBiometrics || isDeviceSupported;
  }

  @override
  Future<bool> validateBiometrics() async{
    try{
      return await localAuthentication.authenticate(
        localizedReason: 'Autentique-se para continuar.',
        options: const AuthenticationOptions(biometricOnly: true)
      );
    }on PlatformException catch(e){ 
      if(e.code == auth_error.notAvailable){
        throw Exception("Aparentemente seu dispositivo não tem suporte a biometria.");
      }else if(e.code == auth_error.notEnrolled){
        throw Exception("Biomtria não encontrada. Por favor, tente novamente.");
      }else{
        throw Exception("Não foi possivel realizar a autenticação. Por favor, tente novamente.");
      }
    }
  }

}