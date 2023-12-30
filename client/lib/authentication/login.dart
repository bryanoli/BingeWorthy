import 'package:flutter/material.dart';
import '../components/custom_form.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return const CustomForm(formType: FormType.login);
  }
}