import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:authentication_flutter/app/features/auth/presentation/home/states/home_store.dart';
import 'package:authentication_flutter/app/shared/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final userStore = Modular.get<UserManagerStore>();
  final homeStore = Modular.get<HomeStore>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    when((_) => !userStore.isLogged, () => userStore.logoff());
    _validateBiometry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: const Text("Home", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => userStore.logoff(),
              icon: const Icon(Icons.exit_to_app, color: Colors.white))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Olá ${userStore.user?.name}",
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              Text(userStore.user?.email ?? ''),
              _divider(),
              Observer(builder: (_) {
                return homeStore.showOptionBiometric
                    ? SwitchListTile(
                        dense: true,
                        title: const Text("Biometria"),
                        value: homeStore.isBiometryRegisted,
                        onChanged: homeStore.changeBiometryValue)
                    : const SizedBox();
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return const Column(
      children: [
        SizedBox(height: 16),
        Divider(),
        SizedBox(height: 16),
      ],
    );
  }

  void _validateBiometry(){
    homeStore.checkRegisteredBiometrics().then((value) {
      if (value != null && !value) _showModalBottomSheet();
    });
  }

  void _showModalBottomSheet() {
    scaffoldKey.currentState!.showBottomSheet((context) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,horizontal: 16
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Biometria Obrigatória!", 
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text("Para continuar navegando pelo aplicativo, é necessario validar sua biometria.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Tentar Novamente',
              onPressed: (){
                Navigator.of(context).pop();
                _validateBiometry();
              }
            ),
            const SizedBox(height: 16),
            CustomButton(
              background: Colors.grey,
              text: 'Entrar com outra Conta',
              onPressed: (){
                Navigator.of(context).pop();
                userStore.logoff();
              }
            ),
          ],
        ),
      );
    }, enableDrag: false, elevation: 5);
  }
}
