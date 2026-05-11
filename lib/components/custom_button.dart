import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String textButton;
  final void Function()? onTap;

  const CustomButton({
    super.key,
    required this.textButton,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(18.0),
        margin: EdgeInsets.symmetric(horizontal: 50.0),
        child: Center(
          child: Text(
            textButton,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.inversePrimary.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
    );
  }
}
