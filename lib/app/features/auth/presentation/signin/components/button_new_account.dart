import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ButtonNewAccount extends StatelessWidget {
  const ButtonNewAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          const TextSpan(
            text: "Ainda não possui um conta? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: " Criar agora.",
            style: const TextStyle(color: Colors.blueAccent),
            recognizer: _openNewAccountScreen()
          )
        ],
      ),
    );
  }

  TapGestureRecognizer _openNewAccountScreen(){
    return TapGestureRecognizer()..onTap = () {
        Modular.to.pushNamed("/register");
    };
  }
}