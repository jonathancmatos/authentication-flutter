// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStoreBase, Store {
  Computed<bool>? _$showOptionBiometricComputed;

  @override
  bool get showOptionBiometric => (_$showOptionBiometricComputed ??=
          Computed<bool>(() => super.showOptionBiometric,
              name: '_HomeStoreBase.showOptionBiometric'))
      .value;

  late final _$_isSupportBiometryAtom =
      Atom(name: '_HomeStoreBase._isSupportBiometry', context: context);

  @override
  bool get _isSupportBiometry {
    _$_isSupportBiometryAtom.reportRead();
    return super._isSupportBiometry;
  }

  @override
  set _isSupportBiometry(bool value) {
    _$_isSupportBiometryAtom.reportWrite(value, super._isSupportBiometry, () {
      super._isSupportBiometry = value;
    });
  }

  late final _$_checkBiometricsActivatedAtom =
      Atom(name: '_HomeStoreBase._checkBiometricsActivated', context: context);

  @override
  bool get _checkBiometricsActivated {
    _$_checkBiometricsActivatedAtom.reportRead();
    return super._checkBiometricsActivated;
  }

  @override
  set _checkBiometricsActivated(bool value) {
    _$_checkBiometricsActivatedAtom
        .reportWrite(value, super._checkBiometricsActivated, () {
      super._checkBiometricsActivated = value;
    });
  }

  late final _$isBiometryRegistedAtom =
      Atom(name: '_HomeStoreBase.isBiometryRegisted', context: context);

  @override
  bool get isBiometryRegisted {
    _$isBiometryRegistedAtom.reportRead();
    return super.isBiometryRegisted;
  }

  @override
  set isBiometryRegisted(bool value) {
    _$isBiometryRegistedAtom.reportWrite(value, super.isBiometryRegisted, () {
      super.isBiometryRegisted = value;
    });
  }

  late final _$_HomeStoreBaseActionController =
      ActionController(name: '_HomeStoreBase', context: context);

  @override
  void changeBiometryValue(bool value) {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.changeBiometryValue');
    try {
      return super.changeBiometryValue(value);
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isBiometryRegisted: ${isBiometryRegisted},
showOptionBiometric: ${showOptionBiometric}
    ''';
  }
}
