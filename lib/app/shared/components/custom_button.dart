import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.height = 56,
  });

  final double? height;
  final String text;
  final bool loading;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: !loading ? () => onPressed() : null ,
        child: Text(text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
