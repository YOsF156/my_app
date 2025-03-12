import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:my_app/firebase_options.dart';
import 'package:my_app/providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isEmailLogin = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Add loading state for login
  bool _obscurePassword = true; // Password visibility toggle

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
      // Sign in with Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print('User signed in: ${userCredential.user?.uid}');

      // Refresh the authentication token to ensure Firestore gets a valid token
      await FirebaseAuth.instance.currentUser?.getIdToken(true);
      print('Auth token refreshed: ${FirebaseAuth.instance.currentUser?.uid}');

      // Wait for auth state to propagate
      await Future.delayed(Duration(milliseconds: 500));

      // Get the user from Firebase Auth
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check if user document exists in Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          // If the document doesn't exist, create it with initial data
          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'email': user.email,
              'createdAt': FieldValue.serverTimestamp(),
              'currentDay': 1, // Start at Day 1
              'completedSessions': [],
              'hasCompletedConfiguration': false, // Initialize this field
            }, SetOptions(merge: true));
            print('User data written to Firestore successfully');
          } catch (firestoreError) {
            print('Firestore write failed during login: $firestoreError');
            // Proceed with navigation even if Firestore fails
          }
        } else {
          print('User document already exists in Firestore: ${userDoc.data()}');
          // Ensure hasCompletedConfiguration exists in the document
          if (!(userDoc.data() as Map<String, dynamic>)
              .containsKey('hasCompletedConfiguration')) {
            try {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .set({
                'hasCompletedConfiguration': false,
              }, SetOptions(merge: true));
              print(
                  'Added missing hasCompletedConfiguration field to Firestore');
            } catch (firestoreError) {
              print('Failed to add hasCompletedConfiguration: $firestoreError');
            }
          }
        }

        // Update lastLogin timestamp regardless of whether the document existed
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'lastLogin': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          print('Last login timestamp updated in Firestore');
        } catch (firestoreError) {
          print('Failed to update last login timestamp: $firestoreError');
          // Proceed with navigation even if Firestore fails
        }

        // Fetch user data from Firestore to store in app-wide state
        DocumentSnapshot updatedUserDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (updatedUserDoc.exists) {
          final userData = updatedUserDoc.data() as Map<String, dynamic>;
          // Update app-wide state with user details
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setUserDetails(
            uid: user.uid,
            email: user.email ?? '',
            createdAt: userData.containsKey('createdAt')
                ? (updatedUserDoc.get('createdAt') as Timestamp?)?.toDate()
                : null,
            currentDay: userData.containsKey('currentDay')
                ? updatedUserDoc.get('currentDay')
                : 1,
            completedSessions: userData.containsKey('completedSessions')
                ? List<String>.from(
                    updatedUserDoc.get('completedSessions') ?? [])
                : [],
            lastLogin: userData.containsKey('lastLogin')
                ? (updatedUserDoc.get('lastLogin') as Timestamp?)?.toDate()
                : null,
            hasCompletedConfiguration:
                userData.containsKey('hasCompletedConfiguration')
                    ? updatedUserDoc.get('hasCompletedConfiguration')
                    : false,
          );
          print('User details stored in app-wide state');
        }

        // Navigate to Home screen after successful login
        Navigator.pushReplacementNamed(context, '/home');
      }
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
          errorMessage = 'Login failed: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF32254B), Color(0xFF32254B)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LogoIpsum', // Placeholder for logo text
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                isEmailLogin ? _buildEmailLoginForm() : _buildInitialLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sleep. Reset. Play',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Start your 30-day journey to better rest with science-backed sleep strategies.',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isEmailLogin = true;
            });
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7B4FFF), Color(0xFFF4A261)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                'Login with Email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            print('Login with Google pressed');
            // Add Google Sign-In logic here later
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7B4FFF), Color(0xFFF4A261)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                'Login with Google',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome back!',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Log in with your email.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 20),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email ID',
            labelStyle: TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 20),
        TextField(
          controller: passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 20),
        if (isLoading)
          CircularProgressIndicator(color: Colors.white)
        else
          ElevatedButton(
            onPressed: _signInWithEmailAndPassword,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7B4FFF), Color(0xFFF4A261)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don’t have an account? ',
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text(
                'Sign Up',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isEmailLogin = false;
            });
          },
          child: Text(
            'Back',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
