import 'package:authentication_flutter/app/features/auth/presentation/signup/states/signup_store.dart';
import 'package:authentication_flutter/app/shared/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final store = Modular.get<SignUpStore>();
  final maskPhoneFormatter = MaskTextInputFormatter(mask: "(##) #####-####");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRIAR NOVA CONTA"),
        centerTitle: true,
      ),
      body: Center(
        child: Observer(builder: (_) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Form(
              key: store.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //Input Name
                  TextFormField(
                    enabled: !store.isLoading,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) => store.nameValidator,
                    onChanged: store.setName,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nome: *",
                    ),
                  ),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 24),
                  //Input Confirm Passwd
                  TextFormField(
                    enabled: !store.isLoading,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) => store.passwdConfirmValidator,
                    onChanged: store.setConfirmPasswd,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Confirmar Senha: *"),
                  ),
                  const SizedBox(height: 24),
                  //Input Phone
                  TextFormField(
                    enabled: !store.isLoading,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) => store.phoneValidator,
                    onChanged: store.setPhone,
                    inputFormatters: [maskPhoneFormatter],
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Telefone:"),
                  ),
                  const SizedBox(height: 40),
                  //Button Register
                  CustomButton(
                    text: "CADASTRAR",
                    onPressed: store.signUp,
                    loading: store.isLoading,
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
