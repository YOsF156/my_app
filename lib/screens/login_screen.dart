import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/firebase_options.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isEmailLogin = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Add loading state for login

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() {
      isLoading = true; // Show loading state
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // If login succeeds, navigate to Home screen
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        default:
          errorMessage = 'Login failed. Please try again later.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: isEmailLogin ? _buildEmailLoginForm() : _buildInitialLogin(),
        ),
      ),
    );
  }

  Widget _buildInitialLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Sleep. Reset. Play'),
        Text(
            'Start your 30-day journey to better rest with science-backed sleep strategies.'),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isEmailLogin = true;
            });
          },
          child: Text('Login with Email'),
        ),
        ElevatedButton(
          onPressed: () {
            print('Login with Google pressed');
            // You can add Google Sign-In with Firebase Authentication here later
          },
          child: Text('Login with Google'),
        ),
      ],
    );
  }

  Widget _buildEmailLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Welcome back!'),
        Text('Log in with your email.'),
        Text('Enter your email to access your account.'),
        SizedBox(height: 20),
        TextField(
          controller: emailController,
          decoration: InputDecoration(labelText: 'Email ID'),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        SizedBox(height: 20),
        if (isLoading)
          CircularProgressIndicator() // Show loading indicator
        else
          ElevatedButton(
            onPressed: _signInWithEmailAndPassword,
            child: Text('LOGIN'),
          ),
        TextButton(
          onPressed: () {
            setState(() {
              isEmailLogin = false;
            });
          },
          child: Text('Back'),
        ),
      ],
    );
  }
}
