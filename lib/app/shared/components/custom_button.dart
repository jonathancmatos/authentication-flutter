import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.background = Colors.blueAccent,
    this.height = 56,
  });

  final double? height;
  final String text;
  final bool loading;
  final Color background;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(background)),
        onPressed: !loading ? () => onPressed() : null ,
        child: Text(text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
