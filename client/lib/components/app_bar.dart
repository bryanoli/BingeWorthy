import 'package:flutter/material.dart';

class _AppBar extends StatefulWidget {
  const _AppBar({super.key});

  @override
  State<_AppBar> createState() => __AppBar();
}

class __AppBar extends State<_AppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Bingelist',
        style: TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
          icon: const Icon(Icons.home),
        ),
      ],
    );
  }
}