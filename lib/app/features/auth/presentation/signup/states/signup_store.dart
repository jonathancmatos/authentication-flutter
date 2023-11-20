import 'package:authentication_flutter/app/core/domain/entities/message.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/new_account_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/new_account.dart';
import 'package:authentication_flutter/app/utils/utils.dart';
import 'package:authentication_flutter/app/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'signup_store.g.dart';

const messageNameNotValid = "Informe seu nome e sobrenome.";
const messageEmailNotValid = "Informe um e-mail válido.";
const messagePasswdNotValid = "A senha precisa ter no mínimo 8 digitos.";
const messagePhoneNotValid = "Informe um telefone válido.";
const String messagePasswdConfirmNotValid = "As duas senhas não coincidem.";

class SignUpStore = _SignUpStoreBase with _$SignUpStore;

abstract class _SignUpStoreBase with Store {
  final NewAccount _newAccount;
  _SignUpStoreBase(NewAccount account) : _newAccount = account;

  @observable
  bool _loading = false;
  bool get isLoading => _loading;

  @observable
  String name = "";
  @action
  void setName(String value) => name = value;
  @computed
  String? get nameValidator => !validateName(name) ? messageNameNotValid : null;

  @observable
  String email = "";
  @action
  void setEmail(String value) => email = value;
  @computed
  String? get emailValidator => !validateEmail(email) ? messageEmailNotValid : null;

  @observable
  String passwd = "";
  @action
  void setPasswd(String value) => passwd = value;
  @computed
  String? get passwdValidator => !validatePasswd(passwd) ? messagePasswdNotValid : null;

  @observable
  String confirmPasswd = "";
  @action
  void setConfirmPasswd(String value) => confirmPasswd = value;
  @computed
  String? get passwdConfirmValidator => !validatePasswd(confirmPasswd) ? messagePasswdNotValid : null;

  @observable
  String phone = "";
  @action
  void setPhone(String value) => phone = value;
  @computed
  String? get phoneValidator =>phone.isNotEmpty && !validatePhone(phone) ? messagePhoneNotValid : null;


  Future<void> signUp({
    required VoidCallback onSuccess,
    required Function(Message message) onFailure
  }) async {
    if (passwd != confirmPasswd) {
      onFailure(const Message(title: "Oops!", text: messagePasswdConfirmNotValid));
      return;
    }
    _loading = true;

    final account = NewAccountEntity(
      name: name,
      passwd: passwd,
      email: email,
      phone: phone,
    );
    final signUpOrFailure = await _newAccount.call(account);

    _loading = false;
    signUpOrFailure?.fold(
      (failure) => onFailure(failureInExeptionConverted(failure)),
      (success) => onSuccess(),
    );
  }
  
}
