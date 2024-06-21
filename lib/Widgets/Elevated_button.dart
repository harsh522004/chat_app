
import 'package:flutter/material.dart';
import '../constant/Colors.dart';

class HelevatedButton extends StatelessWidget {
  HelevatedButton({
    super.key, required this.text, required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      onPressed: onTap,
      style: ElevatedButton.styleFrom(

        backgroundColor: Colors.transparent, // Set button background to transparent
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        padding: EdgeInsets.zero, // Remove default padding
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              materialColor[900]!,
              materialColor[700]!,
            ],
            begin: Alignment.centerLeft, // Start the gradient from the left
            end: Alignment.centerRight, // End the gradient at the right
          ),
          borderRadius: BorderRadius.circular(18), // Set the border radius here
        ),
        child: Container(

          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
