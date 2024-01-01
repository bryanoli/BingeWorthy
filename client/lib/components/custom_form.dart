import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> _submitForm() async {
    final currentContext = context;
    if (formKey.currentState?.validate() ?? false) {
      try {
        if (widget.formType == FormType.login) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
        } else {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          // Additional logic for saving user details to a database can be added here
          Navigator.pushReplacementNamed(currentContext, '/login');
        }
        print('Form submitted!');
      } catch (error) {
        print('Error submitting form: $error');
        // Handle errors as needed
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formType == FormType.login 
        ? 'Login Form' 
        : 'Register Form'),
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
          gradient: const LinearGradient(colors: [Colors.white, Colors.blue]),
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
                  label: 'Enter your first name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  controller: firstNameController,
                ),
              if (widget.formType == FormType.register)
                buildInputField(
                  label: 'Enter your last name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                  controller: lastNameController,
                ),
              if (widget.formType == FormType.register)
                buildInputField(
                  label: 'Enter your username',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  controller: userNameController,
                ),
              buildInputField(
                icon: const Icon(Icons.email),
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
                icon: const Icon(Icons.lock),
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
                  icon: const Icon(Icons.lock),
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
                  child: ElevatedButton(onPressed: _submitForm,
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
    Icon? icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        icon ?? const Icon(Icons.person),
        const Padding(
          padding: EdgeInsets.all(8.0),
          ),
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