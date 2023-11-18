import 'package:authentication_flutter/app/core/domain/entities/message.dart';
import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/sign_in_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/sign_in_with_email.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/sign_in_with_google.dart';
import 'package:authentication_flutter/app/utils/alert_message.dart';
import 'package:authentication_flutter/app/utils/utils.dart';
import 'package:authentication_flutter/app/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'signin_store.g.dart';

class SignInStore = _SignInStore with _$SignInStore;

const messageEmailNotValid = "Informe um e-mail válido.";
const messagePasswdNotValid = "A senha não pode ser vazia.";

abstract class _SignInStore with Store {

  final SignInWithEmail signInWithEmail;
  final SignInWithGoogle signInWithGoogle;

  _SignInStore({
    required this.signInWithEmail,
    required this.signInWithGoogle
  });

  final formKey = GlobalKey<FormState>();

  @observable
  bool _loading = false;
  bool get isLoading => _loading;

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
  String? get passwdValidator => passwd.isEmpty ? messagePasswdNotValid : null;

  @computed
  bool get isFormValid => formKey.currentState!.validate();

  Future<void> signIn({bool isSignSocial = false}) async {
    if (isSignSocial || isFormValid) {
      _loading = true;

      final entity = SignInEntity(email: email, passwd: passwd);
      final signInOrFailure = !isSignSocial 
        ? await signInWithEmail.call(entity)
        : await signInWithGoogle.call();

      _loading = false;
      signInOrFailure?.fold(
        (failure) => _onFailure(failureInExeptionConverted(failure)),
        (success) => _onSuccess(),
      );
    }
  }

  void _onSuccess() async{
    formKey.currentState?.reset();
    final store = Modular.get<UserManagerStore>();
    await store.getCurrentUser().then((_){
      if(store.isLogged) Modular.to.navigate("/me");
    });
  }

  void _onFailure(Message failure) {
    AlertMessage(message: failure.text, type: TypeMessage.error).show();
  }
}
