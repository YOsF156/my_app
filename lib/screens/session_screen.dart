import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionScreen extends StatefulWidget {
  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  bool isPlaying = false; // Tracks whether the session is playing or paused
  double progress = 0.0; // Demo progress (0.0 to 1.0)
  int demoDurationSeconds = 10; // Demo duration in seconds
  late Timer timer; // Timer for demo progress

  @override
  void initState() {
    super.initState();
    print('SessionScreen: initState called');
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel timer when screen is disposed
    super.dispose();
  }

  void _togglePlayPause() {
    print('Toggling Play/Pause - Current State: isPlaying = $isPlaying');
    if (isPlaying) {
      timer.cancel();
    } else {
      print('Starting demo progress...');
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (progress < 1.0) {
            progress += 1.0 / demoDurationSeconds;
            if (progress >= 1.0) {
              progress = 1.0;
              timer.cancel();
              _navigateToSessionCompletion();
            }
          }
        });
      });
    }
    setState(() => isPlaying = !isPlaying);
    print('New Play/Pause State: isPlaying = $isPlaying');
  }

  void _navigateToSessionCompletion() {
    // Navigate to Session Completion screen with current day
    final currentDay =
        (ModalRoute.of(context)?.settings.arguments as int?) ?? 1;
    Navigator.pushReplacementNamed(
      context,
      '/session-completion',
      arguments: currentDay,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Building SessionScreen - isPlaying: $isPlaying, progress: $progress');
    return Scaffold(
      appBar: AppBar(
        title: Text('Today’s Session'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pop(context), // Back to Session Instructions
        ),
      ),
      body: Container(
        color: Colors.white, // Ensure white background
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular Progress Bar (Synced with Demo Progress)
              Container(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                ),
              ),
              SizedBox(height: 10),
              Text('Listening'),
              SizedBox(height: 40),
              // Play/Pause Button with Icon Only
              ElevatedButton(
                onPressed: _togglePlayPause,
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 40,
                ),
              ),
              SizedBox(height: 10),
              // Text Label Below the Button
              Text(
                isPlaying ? 'PAUSE SESSION' : 'PLAY SESSION',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
