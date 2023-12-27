// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignInStore on _SignInStore, Store {
  Computed<String?>? _$emailValidatorComputed;

  @override
  String? get emailValidator => (_$emailValidatorComputed ??= Computed<String?>(
          () => super.emailValidator,
          name: '_SignInStore.emailValidator'))
      .value;
  Computed<String?>? _$passwdValidatorComputed;

  @override
  String? get passwdValidator => (_$passwdValidatorComputed ??=
          Computed<String?>(() => super.passwdValidator,
              name: '_SignInStore.passwdValidator'))
      .value;
  Computed<bool>? _$isButtonEnableComputed;

  @override
  bool get isButtonEnable =>
      (_$isButtonEnableComputed ??= Computed<bool>(() => super.isButtonEnable,
              name: '_SignInStore.isButtonEnable'))
          .value;

  late final _$_loadingAtom =
      Atom(name: '_SignInStore._loading', context: context);

  @override
  bool get _loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$emailAtom = Atom(name: '_SignInStore.email', context: context);

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$passwdAtom = Atom(name: '_SignInStore.passwd', context: context);

  @override
  String get passwd {
    _$passwdAtom.reportRead();
    return super.passwd;
  }

  @override
  set passwd(String value) {
    _$passwdAtom.reportWrite(value, super.passwd, () {
      super.passwd = value;
    });
  }

  late final _$_SignInStoreActionController =
      ActionController(name: '_SignInStore', context: context);

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_SignInStoreActionController.startAction(
        name: '_SignInStore.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_SignInStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPasswd(String value) {
    final _$actionInfo = _$_SignInStoreActionController.startAction(
        name: '_SignInStore.setPasswd');
    try {
      return super.setPasswd(value);
    } finally {
      _$_SignInStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
email: ${email},
passwd: ${passwd},
emailValidator: ${emailValidator},
passwdValidator: ${passwdValidator},
isButtonEnable: ${isButtonEnable}
    ''';
  }
}
