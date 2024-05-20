import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'styles.dart'; // Import the styles
import './firebaseAUTH/auth.dart'; // Import the Authentication class

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password should be at least 6 characters long';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}

class _SignupPageState extends State<SignupPage> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/signUP.jpeg',
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'start the journey',
                    style: AppStyles.titleStyle, // Use the defined title style
                  ),
                ),
                TextFormField(
                  controller: usernameController,
                  validator: widget.validateUsername,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  validator: widget.validateEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  validator: widget.validatePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: confirmPasswordController,
                  validator: (val) => widget.validateConfirmPassword(passwordController.text, val),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signUp();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF4C0F77),
                  ),
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String email = emailController.text;
    String password = passwordController.text;
    String username = usernameController.text;
    String confirmPassword = confirmPasswordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);
    if (user != null) {
      await _saveUserData(user.uid, email, username);
      Navigator.pushNamed(context, "/login");
    } else {
      // Sign-up failed, handle error
    }
  }

  Future<void> _saveUserData(String userId, String email, String username) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
        'username': username,
      });
    } catch (e) {
      // Error saving user data to Firestore, handle error
    }
  }
}
