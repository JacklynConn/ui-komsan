import 'package:flutter/material.dart';

class AppElevatedBtn extends StatelessWidget {

  final void Function()? onPressed;
  final Widget? child;
  final Color? backgroundColor;

  const AppElevatedBtn({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
