import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final store = Modular.get<UserManagerStore>();

  @override
  void initState() {
    super.initState();
    when((_) => !store.isLogged, () => store.logoff());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Olá ${store.user?.name}", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              Text(store.user?.email ?? ''),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => store.logoff(), 
                child: Text("Sair da Conta".toUpperCase())
              )
            ],
          ),
        ),
      ),
    );
  }
}