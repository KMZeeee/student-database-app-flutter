import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {
  final void Function()? onPressed;

  const MyFloatingActionButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: onPressed,
      backgroundColor: Colors.grey[200],
      child: const Icon(Icons.add, color: Colors.black),
    );
  }
}
