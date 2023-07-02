import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter/screens/login_screen.dart';
import 'package:twitter/utils/pick_image.dart';

import 'package:twitter/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 19),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // for extra spacing
            Flexible(
              child: Container(),
              flex: 2,
            ),
            Image.asset(
              'assets/logo.png',
              height: 84,
            ),
            const SizedBox(
              height: 14,
            ),
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 62,
                        backgroundImage: NetworkImage(
                            'https://e7.pngegg.com/pngimages/85/114/png-clipart-avatar-user-profile-male-logo-profile-icon-hand-monochrome-thumbnail.png'),
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        ))),
              ],
            ),
            const SizedBox(height: 24),
            TextFieldInput(
              label: 'Enter your username',
              textEditingController: _usernameController,
              isPass: false,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 24),
            TextFieldInput(
              label: 'Enter your email',
              textEditingController: _emailController,
              isPass: false,
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            TextFieldInput(
              label: 'Enter your password',
              textEditingController: _passwordController,
              isPass: true,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 24),
            TextFieldInput(
              label: 'Enter your bio',
              textEditingController: _bioController,
              isPass: false,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 18.0),
                width: double.infinity,
                height: 50,
                child: Text(
                  'Sign up',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    color: Colors.blue),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Container(),
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                  onTap: navigateToLogin,
                  child: Container(
                    child: Text(
                      "Log in",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      )),
    );
  }
}
