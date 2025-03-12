import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
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
                      'About Us',
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
                    // Sleep Impacts Physically
                    Text(
                      'Sleep Impacts Physically',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Quality sleep is essential for overall health. '
                      'It regulates metabolism, immune function, heart health, '
                      'and muscle recovery. It balances blood sugar, reduces '
                      'inflammation, and supports brain function, memory, and focus. '
                      'Poor sleep "increases stress hormones, disrupts digestion, '
                      'and heightens disease risk, from diabetes to heart disease. '
                      'Prioritizing restorative sleep enhances longevity and overall well-being.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 20),

                    // Sleep Impacts Mentally
                    Text(
                      'Sleep Impacts Mentally',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Quality sleep is crucial for mental well-being, '
                      'enhancing focus, memory, emotional regulation, '
                      'and stress resilience. It supports cognitive '
                      'function, creativity, and decision-making while '
                      'reducing anxiety and depression. Poor sleep '
                      'increases emotional reactivity, impairs '
                      'judgment, and heightens mental fatigue. '
                      'Prioritizing restorative sleep fosters mental '
                      'clarity, stability, and overall psychological health.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 20),

                    // How Emotional Memory Images Impact Sleep Emotionally
                    Text(
                      'How Emotional Memory Images Impact Sleep Emotionally?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Emotional Memory Images (EMIs) link mental and '
                      'physical sleep by storing past stress that '
                      'disrupts rest. Unresolved EMIs trigger stress '
                      'responses, causing fragmented sleep. Clearing '
                      'EMIs helps regulate breathing, relax the nervous '
                      'system, and restore deep, restorative sleep.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 20),

                    // Why SleepReset?
                    Text(
                      'Why SleepReset?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Racism deep, restorative sleep by clearing '
                      'unresolved emotional memory images (EMIs) that '
                      'disrupt your sleep, helping you wake up refreshed, '
                      'energized, and in balance.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              // Logo and Version at the bottom
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFF4A261)
                      .withOpacity(0.2), // Light orange with transparency
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    Text(
                      'LogoIpsum',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'App Version 2.1.0',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
