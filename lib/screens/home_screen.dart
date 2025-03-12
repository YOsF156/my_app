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
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _openSettings, // Open Settings as a slide-in panel
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: _buildHomeContent(
              currentDay, hasCompletedConfiguration, userProvider),
        ),
      ),
    );
  }

  Widget _buildHomeContent(int currentDay, bool hasCompletedConfiguration,
      UserProvider userProvider) {
    if (currentDay <= 30) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(currentDay == 1
              ? 'Welcome to SleepReset'
              : 'Welcome Back Sleep. Reset. Play'),
          Text(
              'Start your 30-day journey to better rest with science-backed sleep strategies.'),
          SizedBox(height: 20),
          Text('Day $currentDay/30 - ${DateTime.now().day} Feb 2025'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (currentDay == 1 && !hasCompletedConfiguration) {
                Navigator.pushNamed(context, '/configuration').then((_) async {
                  // Update Firestore and UserProvider after configuration
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userProvider.uid)
                        .set({
                      'hasCompletedConfiguration': true,
                    }, SetOptions(merge: true));
                    userProvider.updateHasCompletedConfiguration(true);
                    print('Configuration completed and updated in Firestore');
                    _navigateToRandomQuote(currentDay, userProvider);
                  } catch (e) {
                    print('Failed to update hasCompletedConfiguration: $e');
                    // Proceed even if Firestore update fails
                    _navigateToRandomQuote(currentDay, userProvider);
                  }
                });
              } else {
                _navigateToSessionInstructions(currentDay, userProvider);
              }
            },
            child: Text('START TODAY\'S SESSION'),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Program Complete!'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userProvider.uid)
                    .set({
                  'currentDay': 1,
                  'hasCompletedConfiguration': false,
                }, SetOptions(merge: true));
                userProvider.updateCurrentDay(1);
                userProvider.updateHasCompletedConfiguration(false);
                print('Program restarted');
              } catch (e) {
                print('Failed to restart program: $e');
              }
            },
            child: Text('Restart Program'),
          ),
          ElevatedButton(
            onPressed: () {
              print('Fast SleepReset pressed');
            },
            child: Text('Fast SleepReset'),
          ),
        ],
      );
    }
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
