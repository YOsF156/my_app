import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentDay = 1; // Tracks the current day (1–30)
  bool hasCompletedConfiguration = false; // Tracks if configuration is done

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Show settings screen when menu icon is pressed
            Navigator.pushNamed(context, '/settings');
          },
        ),
        actions: [
          // Optional: You can also add a settings icon in the app bar actions
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
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
      // During the 30-day program
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(currentDay == 1
              ? 'Welcome to SleepReset'
              : 'Welcome Back Sleep. Reset. Play'),
          Text(
              'Start your 30-day journey to better rest with science-backed sleep strategies.'),
          SizedBox(height: 20),
          Text(
              'Day $currentDay/30 - ${DateTime.now().day} Feb 2025'), // Simple date placeholder
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (currentDay == 1 && !hasCompletedConfiguration) {
                // Navigate to Configuration screen on Day 1
                Navigator.pushNamed(context, '/configuration').then((_) {
                  setState(() {
                    hasCompletedConfiguration =
                        true; // Mark configuration as complete
                    _navigateToRandomQuote(); // Navigate to Random Quote on Day 1
                  });
                });
              } else {
                _navigateToSessionInstructions(); // Direct to Session Instructions for subsequent days
              }
            },
            child: Text('START TODAY\'S SESSION'),
          ),
        ],
      );
    } else {
      // After 30 days
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Program Complete!'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentDay = 1; // Restart the program
                hasCompletedConfiguration = false; // Reset configuration
              });
            },
            child: Text('Restart Program'),
          ),
          ElevatedButton(
            onPressed: () {
              print(
                  'Fast SleepReset pressed'); // Placeholder for upkeep program
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
      arguments: currentDay == 1, // Pass whether it's the first session
    ).then((_) {
      _navigateToSessionInstructions();
    });
  }

  void _navigateToSessionInstructions() {
    Navigator.pushNamed(
      context,
      '/session-instructions',
      arguments: currentDay == 1, // Pass whether it's the first session
    ).then((_) {
      setState(() {
        if (currentDay < 30) {
          currentDay++;
        } else {
          currentDay = 31; // Trigger post-30-day state
        }
      });
    });
  }
}
