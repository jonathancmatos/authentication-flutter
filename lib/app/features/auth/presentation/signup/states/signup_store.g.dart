// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignUpStore on _SignUpStoreBase, Store {
  Computed<String?>? _$nameValidatorComputed;

  @override
  String? get nameValidator =>
      (_$nameValidatorComputed ??= Computed<String?>(() => super.nameValidator,
              name: '_SignUpStoreBase.nameValidator'))
          .value;
  Computed<String?>? _$emailValidatorComputed;

  @override
  String? get emailValidator => (_$emailValidatorComputed ??= Computed<String?>(
          () => super.emailValidator,
          name: '_SignUpStoreBase.emailValidator'))
      .value;
  Computed<String?>? _$passwdValidatorComputed;

  @override
  String? get passwdValidator => (_$passwdValidatorComputed ??=
          Computed<String?>(() => super.passwdValidator,
              name: '_SignUpStoreBase.passwdValidator'))
      .value;
  Computed<String?>? _$passwdConfirmValidatorComputed;

  @override
  String? get passwdConfirmValidator => (_$passwdConfirmValidatorComputed ??=
          Computed<String?>(() => super.passwdConfirmValidator,
              name: '_SignUpStoreBase.passwdConfirmValidator'))
      .value;
  Computed<String?>? _$phoneValidatorComputed;

  @override
  String? get phoneValidator => (_$phoneValidatorComputed ??= Computed<String?>(
          () => super.phoneValidator,
          name: '_SignUpStoreBase.phoneValidator'))
      .value;
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_SignUpStoreBase.isFormValid'))
          .value;

  late final _$_loadingAtom =
      Atom(name: '_SignUpStoreBase._loading', context: context);

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

  late final _$nameAtom = Atom(name: '_SignUpStoreBase.name', context: context);

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$emailAtom =
      Atom(name: '_SignUpStoreBase.email', context: context);

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

  late final _$passwdAtom =
      Atom(name: '_SignUpStoreBase.passwd', context: context);

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

  late final _$confirmPasswdAtom =
      Atom(name: '_SignUpStoreBase.confirmPasswd', context: context);

  @override
  String get confirmPasswd {
    _$confirmPasswdAtom.reportRead();
    return super.confirmPasswd;
  }

  @override
  set confirmPasswd(String value) {
    _$confirmPasswdAtom.reportWrite(value, super.confirmPasswd, () {
      super.confirmPasswd = value;
    });
  }

  late final _$phoneAtom =
      Atom(name: '_SignUpStoreBase.phone', context: context);

  @override
  String get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  late final _$_SignUpStoreBaseActionController =
      ActionController(name: '_SignUpStoreBase', context: context);

  @override
  void setName(String value) {
    final _$actionInfo = _$_SignUpStoreBaseActionController.startAction(
        name: '_SignUpStoreBase.setName');
    try {
      return super.setName(value);
    } finally {
      _$_SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_SignUpStoreBaseActionController.startAction(
        name: '_SignUpStoreBase.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPasswd(String value) {
    final _$actionInfo = _$_SignUpStoreBaseActionController.startAction(
        name: '_SignUpStoreBase.setPasswd');
    try {
      return super.setPasswd(value);
    } finally {
      _$_SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConfirmPasswd(String value) {
    final _$actionInfo = _$_SignUpStoreBaseActionController.startAction(
        name: '_SignUpStoreBase.setConfirmPasswd');
    try {
      return super.setConfirmPasswd(value);
    } finally {
      _$_SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhone(String value) {
    final _$actionInfo = _$_SignUpStoreBaseActionController.startAction(
        name: '_SignUpStoreBase.setPhone');
    try {
      return super.setPhone(value);
    } finally {
      _$_SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
email: ${email},
passwd: ${passwd},
confirmPasswd: ${confirmPasswd},
phone: ${phone},
nameValidator: ${nameValidator},
emailValidator: ${emailValidator},
passwdValidator: ${passwdValidator},
passwdConfirmValidator: ${passwdConfirmValidator},
phoneValidator: ${phoneValidator},
isFormValid: ${isFormValid}
    ''';
  }
}
