import 'package:flutter/material.dart';
import '../components/custom_form.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return const CustomForm(formType: FormType.register);
  }
}