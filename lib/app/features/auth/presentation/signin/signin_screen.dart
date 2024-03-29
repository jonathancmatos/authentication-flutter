import 'package:authentication_flutter/app/core/domain/entities/message.dart';
import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:authentication_flutter/app/features/auth/presentation/signin/components/button_new_account.dart';
import 'package:authentication_flutter/app/features/auth/presentation/signin/states/signin_store.dart';
import 'package:authentication_flutter/app/shared/components/custom_button.dart';
import 'package:authentication_flutter/app/utils/alert_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final store = Modular.get<SignInStore>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("LOGIN"),
          centerTitle: true,
        ),
        body: Observer(builder: (_) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //Input E-mail
                    TextFormField(
                      enabled: !store.isLoading,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (v) => store.emailValidator,
                      onChanged: store.setEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "E-mail: *",
                      ),
                    ),
                    const SizedBox(height: 24),
                    //Input Passwd
                    TextFormField(
                      enabled: !store.isLoading,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (v) => store.passwdValidator,
                      onChanged: store.setPasswd,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Senha: *"),
                    ),
                    const SizedBox(height: 40),
                    //Button Login
                    CustomButton(
                      text: "ENTRAR",
                      onPressed: () => store.signIn(
                        onSuccess: _onSuccess,
                        onError: _onFailure
                      ),
                      loading: !store.isButtonEnable,
                    ),
                    const SizedBox(height: 24),
                    //Button Sign Google
                    CustomButton(
                      text: "Entrar com o Google",
                      onPressed: () => store.signIn(
                        isSignSocial: true,
                        onSuccess: _onSuccess,
                        onError: _onFailure
                      ),
                      loading: store.isLoading,
                      background: Colors.redAccent,
                    ),
                    const SizedBox(height: 40),
                    //Button New Account
                    const ButtonNewAccount(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
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
