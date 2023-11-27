import 'dart:convert';
import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/user_entity.dart';
import 'package:authentication_flutter/app/services/biometry/biometry_service.dart';
import 'package:authentication_flutter/app/services/storage/storage_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'home_store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {

  static const String _keyStorage = "biometrics";

  _HomeStoreBase({
    required this.biometryService,
    required this.storageService
  }){
    biometryService.isSupportBiometry().then((value) => _isSupportBiometry = value);
    biometryService.checkBiometricsActivated().then((value) => _checkBiometricsActivated = value);
  }

  final BiometryService biometryService;
  final StorageService storageService;
  
  UserEntity? user = Modular.get<UserManagerStore>().user;

  @observable
  bool _isSupportBiometry = false;

  @observable
  bool _checkBiometricsActivated = false;

  @observable 
  bool isBiometryRegisted = false;

  @action
  void changeBiometryValue(bool value){
    if(value){
      _registerBiometrics();
    }else{
      _removeBiometrics();
    }
  }

  @computed
  bool get showOptionBiometric => _isSupportBiometry && _checkBiometricsActivated;

  Future<bool> _validateBiometrics() async{
    return await biometryService.validateBiometrics()
      .then((value) => value)
      .catchError((onError) => false);
  }


  Future<bool?> checkRegisteredBiometrics() async{
    final result = storageService.read(key: _keyStorage);
    if(result != null && result.isNotEmpty){
      List list = await json.decode(result);
      isBiometryRegisted = list.contains(user?.email);
      if(isBiometryRegisted) return await _validateBiometrics();
    }
    return null;
  }

  Future _registerBiometrics() async{
    final result = storageService.read(key: _keyStorage);
    List list = result != null ? await json.decode(result) : [];
    if(!list.contains(user?.email)){
      list.add(user?.email ?? '');
      storageService.save(key: _keyStorage, value: json.encode(list));
      isBiometryRegisted = true;
    }
  }

  Future _removeBiometrics() async{
    final result = storageService.read(key: _keyStorage);
    List list = await json.decode(result ?? '');
    if(list.contains(user?.email)){
      list.remove(user?.email ?? '');
      storageService.save(key: _keyStorage, value: json.encode(list));
      isBiometryRegisted = false;
    }
  }
}