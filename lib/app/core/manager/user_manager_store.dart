import 'package:authentication_flutter/app/features/auth/domain/entities/user_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/get_current_user.dart';
import 'package:authentication_flutter/app/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'user_manager_store.g.dart';

class UserManagerStore = _UserManagerStoreBase with _$UserManagerStore;

abstract class _UserManagerStoreBase with Store {

  final GetCurrentUser _usercase;
  _UserManagerStoreBase(this._usercase);

  @observable
  bool _loading = false;

  @computed
  bool get isLoading => _loading; 

  @observable
  UserEntity? user;

  @computed
  bool get isLogged => user != null && user!.name.isNotEmpty;

  Future<void> getCurrentUser() async{
    _loading = true;

    final result = await _usercase.call();
    result?.fold(
      (failure){
        if (kDebugMode) {
          print(failureInExeptionConverted(failure).text.toString());
        }
      }, 
      (userInfo){
        if(userInfo != null){
          user = userInfo;
        }
      }
    );

    _loading = false;
  }

  void logout(){
    Modular.to.navigate("/login");
  }

}