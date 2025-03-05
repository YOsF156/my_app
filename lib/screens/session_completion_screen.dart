import 'package:flutter/material.dart';

class SessionCompletionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current day from route arguments (default to 1 if not provided)
    final int currentDay =
        ModalRoute.of(context)?.settings.arguments as int? ?? 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Session Completion'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Back to Session Screen
        ),
      ),
      body: Container(
        color: Colors.white, // Ensure white background
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.thumb_up, size: 50), // Placeholder for thumb-up icon
                SizedBox(height: 20),
                Text(
                  'Well done! Your mind is clearing more and more each day, to create a better night’s sleep',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Text(
                  '$currentDay Day Session Completed. See you tomorrow!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'We will remind you tomorrow at 10:00 PM for your next session',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/reminders',
                      arguments:
                          currentDay, // Pass current day for reminder context
                    );
                  },
                  child: Text('SET NEXT REMINDER TIME'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
