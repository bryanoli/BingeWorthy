import 'package:flutter/material.dart';
import 'package:client/components/menu_drawer.dart';

class _WorldsLiState extends StatefulWidget {
  const _WorldsLiState({super.key});

  @override
  State<_WorldsLiState> createState() => __WorldsLiStateState();
}

class __WorldsLiStateState extends State<_WorldsLiState> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer:MenuDrawer(),
      body: Center(
        child: Text('Worlds List'),
      ),
    );
  }
}