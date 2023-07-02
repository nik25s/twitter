import 'package:flutter/material.dart';
import 'package:twitter/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png',
            height: 84,
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldInput(
            textEditingController: _emailController,
            label: 'Enter you Email',
            textInputType: TextInputType.emailAddress,
            isPass: false,
          ),
          const SizedBox(
            height: 16,
          ),
          TextFieldInput(
            textEditingController: _passwordController,
            label: 'Enter you Password',
            textInputType: TextInputType.text,
            isPass: true,
          ),
        ],
      )),
    ));
  }
}
