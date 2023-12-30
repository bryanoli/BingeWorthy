import 'package:flutter/material.dart';

enum FormType { login, register }

class CustomForm extends StatefulWidget {
  final FormType formType;

  const CustomForm({Key? key, required this.formType}) : super(key: key);

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material( // Wrap with Material widget
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
          gradient: const LinearGradient(colors: [Colors.lightBlueAccent, Colors.blue]),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(4.0, 4.0),
            ),
          ],
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              if (widget.formType == FormType.register)
                buildInputField(
                  label: 'Enter your name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  controller: nameController,
                ),
              buildInputField(
                label: 'Enter your email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                controller: emailController,
              ),
              buildInputField(
                label: 'Enter your password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                controller: passwordController,
                obscureText: true,
              ),
              if (widget.formType == FormType.register)
                buildInputField(
                  label: 'Confirm your password',
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  controller: confirmPasswordController,
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: () {
                    // Handle form submission here
                    if (formKey.currentState?.validate() ?? false) {
                      print('Form submitted!');
                    }
                  },
                  child: const Text('Submit'),
                                ),
                ),
              if (widget.formType == FormType.login)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(onPressed: (){
                    Navigator.pushNamed(context, '/register');
                  }, child: const Text('Don\'t have an account? Register here!')),
                ),
              if (widget.formType == FormType.register)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(onPressed: (){
                    Navigator.pushNamed(context, '/login');
                  }, child: const Text('Already have an account? Login here!')),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required String label,
    required String? Function(String?) validator,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextFormField(
          keyboardType: keyboardType,
          controller: controller,
          validator: validator,
          obscureText: obscureText,
        ),
      ],
    );
  }
}