import 'package:flutter/material.dart';
import 'package:my_app/screens/settings_screen.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentDay = 1; // Tracks the current day (1–30)
  bool hasCompletedConfiguration = false; // Tracks if configuration is done

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
          child: _buildHomeContent(),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
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
                Navigator.pushNamed(context, '/configuration').then((_) {
                  setState(() {
                    hasCompletedConfiguration = true;
                    _navigateToRandomQuote();
                  });
                });
              } else {
                _navigateToSessionInstructions();
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
            onPressed: () {
              setState(() {
                currentDay = 1;
                hasCompletedConfiguration = false;
              });
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

  void _navigateToRandomQuote() {
    Navigator.pushNamed(
      context,
      '/random-quote',
      arguments: currentDay == 1,
    ).then((_) {
      _navigateToSessionInstructions();
    });
  }

  void _navigateToSessionInstructions() {
    Navigator.pushNamed(
      context,
      '/session-instructions',
      arguments: currentDay == 1,
    ).then((_) {
      setState(() {
        if (currentDay < 30)
          currentDay++;
        else
          currentDay = 31;
      });
    });
  }
}
