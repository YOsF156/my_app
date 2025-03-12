import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/providers/user_provider.dart';
import 'package:my_app/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _openSettings() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => SettingsScreen(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(-1, 0), // Start off-screen to the left
            end: Offset(0, 0), // End at the left edge
          ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentDay = userProvider.currentDay ?? 1;
    final hasCompletedConfiguration =
        userProvider.hasCompletedConfiguration ?? false;

    // If userProvider.uid is null, redirect to login (user not logged in)
    if (userProvider.uid == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: _openSettings, // Open Settings as a slide-in panel
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF32254B), Color(0xFF32254B).withOpacity(0.8)],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20), // Padding for the entire content
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Moon GIF (assumed placed in assets/moon.gif)
                Image.asset(
                  'assets/moon.gif', // Already downloaded and placed here
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 20),
                // Welcome Text
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Sleep. Reset. Play',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                // Progress Circle
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: currentDay / 30,
                        strokeWidth: 10,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF00C4CC)),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '0$currentDay/30',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '04 Feb 2025', // Replace with dynamic date if needed
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40),
                // Start Session Button with adjusted padding
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0), // Minimal padding on the sides
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentDay == 1 && !hasCompletedConfiguration) {
                        Navigator.pushNamed(context, '/configuration')
                            .then((_) async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(userProvider.uid)
                                .set({
                              'hasCompletedConfiguration': true,
                            }, SetOptions(merge: true));
                            userProvider.updateHasCompletedConfiguration(true);
                            print(
                                'Configuration completed and updated in Firestore');
                            _navigateToRandomQuote(currentDay, userProvider);
                          } catch (e) {
                            print(
                                'Failed to update hasCompletedConfiguration: $e');
                            _navigateToRandomQuote(currentDay, userProvider);
                          }
                        });
                      } else {
                        _navigateToSessionInstructions(
                            currentDay, userProvider);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), // Full width
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
                          'START TODAY\'S SESSION',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToRandomQuote(int currentDay, UserProvider userProvider) {
    Navigator.pushNamed(
      context,
      '/random-quote',
      arguments: currentDay == 1,
    ).then((_) {
      _navigateToSessionInstructions(currentDay, userProvider);
    });
  }

  void _navigateToSessionInstructions(
      int currentDay, UserProvider userProvider) {
    Navigator.pushNamed(
      context,
      '/session-instructions',
      arguments: currentDay == 1,
    ).then((_) async {
      if (currentDay < 30) {
        try {
          final newDay = currentDay + 1;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userProvider.uid)
              .set({
            'currentDay': newDay,
          }, SetOptions(merge: true));
          userProvider.updateCurrentDay(newDay);
          print('Progressed to day $newDay');
        } catch (e) {
          print('Failed to update currentDay: $e');
        }
      } else {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userProvider.uid)
              .set({
            'currentDay': 31,
          }, SetOptions(merge: true));
          userProvider.updateCurrentDay(31);
          print('Program completed');
        } catch (e) {
          print('Failed to update currentDay to 31: $e');
        }
      }
    });
  }
}
