import 'package:flutter/material.dart';

class SessionInstructionsScreen extends StatefulWidget {
  @override
  _SessionInstructionsScreenState createState() =>
      _SessionInstructionsScreenState();
}

class _SessionInstructionsScreenState extends State<SessionInstructionsScreen> {
  bool? isFirstSession;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Determine if it's the first session after dependencies are available
    isFirstSession = ModalRoute.of(context)?.settings.arguments as bool?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pop(context), // Back to Home or previous screen
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
                Text('Session 01/30'),
                SizedBox(height: 20),
                Text(isFirstSession ?? false
                    ? 'Welcome to your first SleepReset session'
                    : 'Welcome back to SleepReset'),
                Text(
                    'Before we begin, please connect your earphones, make sure that you are in a quiet comfortable place and can’t be disturbed for the next few minutes.'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showHeadphoneReminder(context);
                  },
                  child: Text('BEGIN SESSION'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHeadphoneReminder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white, // White background for popup
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0)), // Rounded top corners
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Makes the bottom sheet only as tall as its content
            children: [
              Text('SleepReset',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                'SleepReset works best when used with earphones, otherwise, you may significantly reduce your results.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure you want to continue?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                          context); // Dismiss the popup and stay on the current screen
                    },
                    child: Text('NO'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Dismiss the popup
                      // Proceed to the Session screen
                      Navigator.pushReplacementNamed(context, '/session');
                    },
                    child: Text('YES'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
