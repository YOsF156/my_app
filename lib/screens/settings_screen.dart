// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Function to show reset progress confirmation dialog
  void _showResetProgressDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Color(0xFF32254B), // Dark purple background
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFF32254B),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.question_answer,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Do you really want to reset your progress?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // NO button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        'NO',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // YES button
                    ElevatedButton(
                      onPressed: () {
                        // Reset progress logic here
                        Navigator.of(context).pop(); // Close dialog
                        _resetProgress();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        'YES',
                        style: TextStyle(color: Color(0xFF32254B)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to reset progress
  void _resetProgress() {
    // Here you would reset the user's progress in Firebase
    // For now, we'll just navigate to the success screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProgressResetSuccessfulScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black.withOpacity(0.5), // Semi-transparent background
      body: Center(
        child: Container(
          width: 300, // Adjust width as needed
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with "Settings" and close button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Color(0xFF32254B), // Dark purple header
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              // Settings options
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    // Reset Progress
                    _buildSettingOption(
                      icon: Icons.restart_alt,
                      title: 'Reset Progress',
                      onTap: _showResetProgressDialog,
                    ),
                    // Change Password
                    _buildSettingOption(
                      icon: Icons.lock,
                      title: 'Change Password',
                      onTap: () {
                        // Add change password logic
                      },
                    ),
                    // Set Reminder Time
                    _buildSettingOption(
                      icon: Icons.access_time,
                      title: 'Set Reminder Time',
                      onTap: () {
                        Navigator.pushNamed(context, '/reminders');
                      },
                    ),
                    // Privacy Policy / Terms of Use
                    _buildSettingOption(
                      icon: Icons.description,
                      title: 'Privacy Policy / Terms of Use',
                      onTap: () {
                        // Add privacy policy navigation
                      },
                    ),
                    // Contact Support
                    _buildSettingOption(
                      icon: Icons.support_agent,
                      title: 'Contact Support',
                      onTap: () {
                        // Add contact support logic
                      },
                    ),
                    // About SleepReset
                    _buildSettingOption(
                      icon: Icons.info,
                      title: 'About SleepReset',
                      onTap: () {
                        // Add about screen navigation
                      },
                    ),
                  ],
                ),
              ),
              // App version at the bottom
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'App Version 2.1.0',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build setting options
  Widget _buildSettingOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF32254B)),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Progress Reset Successful Screen
class ProgressResetSuccessfulScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF32254B),
              Color(0xFF32254B)
            ], // Dark purple background
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo at the top
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "LogoIpsum",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                // Success icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(height: 20),
                // Success message
                Text(
                  'Progress Reset Successful',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your Progress has been updated.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                // Back to Home button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.white),
                      ),
                    ),
                    child: Text(
                      'BACK TO HOME',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Bottom indicator
                Container(
                  width: 100,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
