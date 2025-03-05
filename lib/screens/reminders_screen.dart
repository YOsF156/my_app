import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Updated for intl: ^0.20.2

class RemindersScreen extends StatefulWidget {
  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool isReminderEnabled = false; // Toggle for reminder alerts
  TimeOfDay? selectedTime; // Selected reminder time
  int? currentDay; // Current day from arguments (nullable)
  bool showConfirmation =
      false; // State to show/hide confirmation (added this line)

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Determine the current day after dependencies are available
    currentDay = ModalRoute.of(context)?.settings.arguments as int?;
  }

  @override
  void initState() {
    super.initState();
    selectedTime = TimeOfDay.now(); // Default to current time
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _saveReminder() {
    if (isReminderEnabled && selectedTime != null) {
      setState(() {
        showConfirmation = true; // Show confirmation dialog
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enable reminders and select a time')),
      );
    }
  }

  void _confirmBackToHome() {
    setState(() {
      showConfirmation = false; // Hide confirmation
    });
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Back to Session Completion
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
                SwitchListTile(
                  title: Text('Reminder Alerts'),
                  value: isReminderEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      isReminderEnabled = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                if (isReminderEnabled)
                  Column(
                    children: [
                      ListTile(
                        title: Text('Reminder Time'),
                        subtitle: Text(selectedTime != null
                            ? DateFormat.jm().format(DateTime(0, 0, 0,
                                selectedTime!.hour, selectedTime!.minute))
                            : 'Not set'),
                        trailing: Icon(Icons.access_time),
                        onTap: () => _selectTime(context),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _saveReminder,
                        child: Text('SAVE'),
                      ),
                    ],
                  ),
                if (showConfirmation)
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Icon(Icons.check_circle,
                            size: 50), // Placeholder for circle with V inside
                        SizedBox(height: 20),
                        Text(
                          'Reminder Saved Successfully',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'We will remind you on ${(currentDay ?? 1) + 1} Day at ${selectedTime != null ? DateFormat.jm().format(DateTime(0, 0, 0, selectedTime!.hour, selectedTime!.minute)) : '10:00 PM'} for your next session',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _confirmBackToHome,
                          child: Text('BACK TO HOME'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
