import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final store = Modular.get<UserManagerStore>();

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    await store.getCurrentUser();
    autorun((_){
      if(!store.isLoading && store.isLogged){
        Modular.to.navigate("/me");
      }else if(!store.isLoading){
        Modular.to.navigate("/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator()
      ),
    );
  }
}