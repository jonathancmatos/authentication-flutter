import 'package:authentication_flutter/main.dart';
import 'package:flutter/material.dart';

enum TypeMessage {success, error,info}

class AlertMessage {

  final String message;
  final TypeMessage type;

  AlertMessage({required this.message, this.type = TypeMessage.info});

  Color _getBackgroudColor(TypeMessage type){
    switch(type){
      case TypeMessage.success:
        return Colors.green;
      case TypeMessage.error:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  void show() {
    final context = globalKeyNavigator.currentState!.overlay!.context;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: _getBackgroudColor(type),
      duration: const Duration(seconds: 3),
    ));
  }

}
