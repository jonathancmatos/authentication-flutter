
abstract class BiometryService{
  Future<bool> isSupportBiometry();
  Future<bool> checkBiometricsActivated();
  Future<bool> validateBiometrics();
}