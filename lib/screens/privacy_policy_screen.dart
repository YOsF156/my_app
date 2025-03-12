import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
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
          child: Column(
            children: [
              // AppBar with back arrow and title
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Color(0xFF32254B),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 48), // Placeholder to balance the row
                  ],
                ),
              ),
              // Scrollable content
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    // Introduction
                    Text(
                      'This privacy policy defines how we manage '
                      'information and data that identifies you, directly '
                      'or indirectly (the "Personal Data") when you use '
                      'our Services. Please read the following carefully '
                      'to understand our practices regarding your '
                      'Personal Data.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 20),

                    // Personal data that we process
                    Text(
                      '1. Personal data that we process',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Those that you provide directly.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Using our Services, especially when you '
                      'create an account, you connect to it, view our '
                      'videos or participate in our games, you are '
                      'prompted to provide information and thus '
                      'provide us with some Personal Data type '
                      'with information.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This information includes, to the extent '
                      'necessary and without this list being exhaustive:',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Personal Data necessary to register for our '
                      'Services, namely your email address and '
                      'password, and to take advantage of our paid '
                      'services, your bank details;',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'You may also choose to provide us with '
                      'additional information such as your gender, first '
                      'name, last name, profile picture and address. '
                      'However, unlike the aforementioned information, '
                      'this additional information is not mandatory in '
                      'order to validate your subscription to the '
                      'Services. Nevertheless, they allow us to '
                      'personalize our relationship;',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Personal Data that you provide to us in order '
                      'to contact us, in particular via the online contact '
                      'form such as your email address, the content of '
                      'your request and any attachments',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              // Logo and Version at the bottom (optional, can be added later if needed)
              // For now, we'll omit it since the design doesn't show it here
            ],
          ),
        ),
      ),
    );
  }
}
