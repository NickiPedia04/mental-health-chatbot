import 'package:flutter/material.dart';

class CustomPasswordTextfield extends StatefulWidget {
  final String hintText;
  final TextEditingController textController;
  final double horzonPadding;

  const CustomPasswordTextfield({
    super.key,
    required this.hintText,
    required this.textController,
    required this.horzonPadding,
  });

  @override
  State<CustomPasswordTextfield> createState() => _CustomPasswordTextfield();
}

class _CustomPasswordTextfield extends State<CustomPasswordTextfield> {
  bool obscured = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horzonPadding),
      child: TextField(
        controller: widget.textController,
        obscureText: obscured ? true : false,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          fillColor: Theme.of(context).colorScheme.primary,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.inversePrimary.withValues(alpha: 0.4),
          ),
          suffixIcon: Opacity(
            opacity: 0.4,
            child: IconButton(
              onPressed: () => {
                setState(() {
                  obscured = !obscured;
                }),
              },
              icon: obscured
                  ? Icon(Icons.visibility_off)
                  : Icon(Icons.visibility),
            ),
          ),
        ),
      ),
    );
  }
}
