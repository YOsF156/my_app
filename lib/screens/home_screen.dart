import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/utils/asset_helper.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _flashingController;
  final Random _random = Random();
  final List<_Star> _stars = [];

  @override
  void initState() {
    super.initState();
    _flashingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    for (int i = 0; i < 30; i++) {
      _stars.add(_Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2 + 1,
        baseOpacity: _random.nextDouble() * 0.3 + 0.2,
      ));
    }
  }

  @override
  void dispose() {
    _flashingController.dispose();
    super.dispose();
  }

  void _openSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return DateFormat('dd MMM yyyy').format(now);
  }

  String _getFormattedDay(int currentDay) {
    return currentDay < 10 ? '0$currentDay/30' : '$currentDay/30';
  }

  Widget _buildMainContent(int currentDay, bool hasCompletedConfiguration, double screenHeight) {
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.05),
        Image.asset(
          'assets/moon.gif',
          width: 100,
          height: 100,
        ),
        SizedBox(height: 24),
        Text(
          currentDay == 1 ? 'Welcome to\nSleepReset' : 'Welcome Back',
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.24,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            currentDay == 1
                ? 'Start your 30-day journey to better rest with science-backed sleep strategies.'
                : 'Sleep. Reset. Play',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              letterSpacing: 0.16,
              height: currentDay == 1 ? 1.625 : 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userProvider.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          print('Error fetching user data: ${snapshot.error}');
          return Scaffold(
            body: Center(child: Text('Error loading data')),
          );
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          userProvider.setUserDetails(
            uid: userProvider.uid!,
            email: userProvider.email!,
            createdAt: (userData['createdAt'] as Timestamp?)?.toDate(),
            currentDay: userData['currentDay'] ?? 1,
            completedSessions: List<String>.from(userData['completedSessions'] ?? []),
            lastLogin: (userData['lastLogin'] as Timestamp?)?.toDate(),
            hasCompletedConfiguration: userData['hasCompletedConfiguration'] ?? false,
          );
        }

        final currentDay = userProvider.currentDay ?? 1;
        final hasCompletedConfiguration = userProvider.hasCompletedConfiguration ?? false;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2A1965),
            ),
            child: Stack(
              children: [
                _buildConstellationEffect(),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: _openSettings,
                              child: Container(
                                width: 40,
                                height: 40,
                                padding: EdgeInsets.all(8),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 4,
                                      left: 0,
                                      child: AssetHelper.loadSvg(
                                        'assets/images/menu_vector1.svg',
                                        width: 24,
                                        height: 2,
                                      ),
                                    ),
                                    Positioned(
                                      top: 11,
                                      left: 0,
                                      child: AssetHelper.loadSvg(
                                        'assets/images/menu_vector2.svg',
                                        width: 16,
                                        height: 2,
                                      ),
                                    ),
                                    Positioned(
                                      top: 18,
                                      left: 0,
                                      child: AssetHelper.loadSvg(
                                        'assets/images/menu_vector3.svg',
                                        width: 20,
                                        height: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (currentDay == 1)
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetHelper.loadImage('assets/images/profile_image.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildMainContent(currentDay, hasCompletedConfiguration, screenHeight),
                              SizedBox(height: screenHeight * 0.05),
                              _buildCurrentDayComponent(currentDay),
                              SizedBox(height: screenHeight * 0.1),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          bottom: 20.0 + MediaQuery.of(context).padding.bottom,
                        ),
                        child: InkWell(
                          onTap: () {
                            if (currentDay == 1 && !hasCompletedConfiguration) {
                              Navigator.pushNamed(context, '/configuration').then((_) async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userProvider.uid)
                                      .set({
                                    'hasCompletedConfiguration': true,
                                  }, SetOptions(merge: true));
                                  userProvider.updateHasCompletedConfiguration(true);
                                  _navigateToRandomQuote(currentDay, userProvider);
                                } catch (e) {
                                  print('Failed to update hasCompletedConfiguration: $e');
                                  _navigateToRandomQuote(currentDay, userProvider);
                                }
                              });
                            } else {
                              _navigateToSessionInstructions(currentDay, userProvider);
                            }
                          },
                          child: Container(
                            width: 370,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [Color(0xFFD56CFF), Color(0xFFF3B775)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "START TODAY'S SESSION",
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentDayComponent(int currentDay) {
    return Container(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFE594E8).withOpacity(0.1),
                  blurRadius: 50,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF543EA7).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF543EA7),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE594E8).withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF0864A6),
                        Color(0xFF55E4EC),
                        Color(0xFF37A8AE),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 0.7, 1.0],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getFormattedDay(currentDay),
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.35,
                      ),
                    ),
                    SizedBox(height: 4),
                    AssetHelper.loadSvg(
                      'assets/images/date_vector.svg',
                      width: 24,
                      height: 2,
                    ),
                    SizedBox(height: 4),
                    Text(
                      _getCurrentDate(),
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        letterSpacing: 0.14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConstellationEffect() {
    return AnimatedBuilder(
      animation: _flashingController,
      builder: (context, child) {
        return CustomPaint(
          painter: ConstellationPainter(
            opacity: _flashingController.value,
            stars: _stars,
          ),
          size: Size.infinite,
        );
      },
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

  void _navigateToSessionInstructions(int currentDay, UserProvider userProvider) {
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
          print('Completed all 30 days');
        } catch (e) {
          print('Failed to update currentDay: $e');
        }
      }
    });
  }
}

class ConstellationPainter extends CustomPainter {
  final double opacity;
  final List<_Star> stars;

  ConstellationPainter({
    required this.opacity,
    required this.stars,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var star in stars) {
      paint.color = Color(0xFFB4A0D8).withOpacity(star.baseOpacity * opacity);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ConstellationPainter oldDelegate) => oldDelegate.opacity != opacity;
}

class _Star {
  final double x;
  final double y;
  final double size;
  final double baseOpacity;

  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.baseOpacity,
  });
}