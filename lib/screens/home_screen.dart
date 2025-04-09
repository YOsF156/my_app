import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/utils/asset_helper.dart';
import 'package:my_app/widgets/gradient_button.dart';
import 'dart:math';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _flashingController;
  late AnimationController _ellipseRotationController;
  late AnimationController _cometController;
  final Random _random = Random();
  final List<_Star> _stars = [];
  Offset? _cometStartPosition;
  Offset? _cometEndPosition;
  Timer? _cometTimer;
  late Future<DocumentSnapshot> _userDataFuture;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _userDataFuture = FirebaseFirestore.instance.collection('users').doc(userProvider.uid).get();

    _flashingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _ellipseRotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    )..repeat();

    _cometController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });

    for (int i = 0; i < 30; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: _random.nextInt(2000) + 1000),
      )..repeat(reverse: true);
      _stars.add(_Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2 + 1,
        baseOpacity: _random.nextDouble() * 0.3 + 0.2,
        controller: controller,
      ));
    }

    _startCometAnimation();
  }

  void _startCometAnimation() {
    _cometTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _cometStartPosition = Offset(0, _random.nextDouble() * MediaQuery.of(context).size.height * 0.3);
          _cometEndPosition = Offset(
            MediaQuery.of(context).size.width,
            _cometStartPosition!.dy + MediaQuery.of(context).size.height * 0.2,
          );
          _cometController.forward(from: 0);
        });
      }
    });
  }

  @override
  void dispose() {
    _flashingController.dispose();
    _ellipseRotationController.dispose();
    _cometController.dispose();
    _cometTimer?.cancel();
    for (var star in _stars) {
      star.controller.dispose();
    }
    super.dispose();
  }

  void _openSettings() {
    print('Settings button pressed');
    Navigator.pushNamed(context, '/settings');
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return DateFormat('dd MMM yyyy').format(now);
  }

  String _getFormattedDay(int currentDay) {
    return currentDay < 10 ? '0$currentDay' : '$currentDay';
  }

  Widget _buildMainContent(int currentDay, bool hasCompletedConfiguration, double screenHeight) {
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.05),
        Image.asset(
          'assets/moon.gif',
          width: 120,
          height: 120,
        ),
        SizedBox(height: 24),
        Text(
          currentDay == 1 ? 'Welcome to\nSleepReset' : 'Welcome Back',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
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
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
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

    if (userProvider.uid == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          print('Error fetching user data: ${snapshot.error}');
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading data: ${snapshot.error}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _userDataFuture = FirebaseFirestore.instance
                            .collection('users')
                            .doc(userProvider.uid)
                            .get();
                      });
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
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
        } else {
          print('User document does not exist');
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('User data not found'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Text('Go to Login'),
                  ),
                ],
              ),
            ),
          );
        }

        final currentDay = userProvider.currentDay ?? 1;
        final hasCompletedConfiguration = userProvider.hasCompletedConfiguration ?? false;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2A1965), Color(0xFF32254B)],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: AssetHelper.loadSvg(
                    'assets/images/session/ellipse_35_top.svg',
                    width: 100,
                    height: 100,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: AssetHelper.loadSvg(
                    'assets/images/session/ellipse_37.svg',
                    width: 100,
                    height: 100,
                  ),
                ),
                _buildConstellationEffect(),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Container(
                                width: 40,
                                height: 40,
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
                              onPressed: () {
                                print('Menu button tapped');
                                _openSettings();
                              },
                            ),
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
                        child: GradientButton(
                          text: "START TODAY'S SESSION",
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
      width: 180, // Smaller overall size
      height: 180, // Perfect circle
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating ellipse (adjusted size)
          RotationTransition(
            turns: _ellipseRotationController,
            child: AssetHelper.loadSvg(
              'assets/images/ellipse_around_circle.svg',
              width: 200, // Slightly smaller to match the new size
              height: 200,
            ),
          ),
          // Progress ring
          CustomPaint(
            painter: ProgressRingPainter(
              progress: currentDay / 30,
            ),
            child: Container(
              width: 160, // Adjusted to match the new size
              height: 160,
            ),
          ),
          // Main circle with subtle aura
          Container(
            width: 140, // Thicker inner circle (smaller inner diameter)
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF543EA7),
                  Color(0xFF32254B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFE594E8).withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _getFormattedDay(currentDay),
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 28, // Adjusted for smaller size
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.35,
                            ),
                      ),
                      TextSpan(
                        text: '/30',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 18, // Adjusted for smaller size
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.35,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                AssetHelper.loadSvg(
                  'assets/images/date_vector.svg',
                  width: 18, // Adjusted for smaller size
                  height: 2,
                ),
                SizedBox(height: 4),
                Text(
                  _getCurrentDate(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 12, // Adjusted for smaller size
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.14,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConstellationEffect() {
    return CustomPaint(
      painter: ConstellationPainter(
        stars: _stars,
        cometStartPosition: _cometStartPosition,
        cometEndPosition: _cometEndPosition,
        cometProgress: _cometController.value,
      ),
      size: Size.infinite,
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

class ProgressRingPainter extends CustomPainter {
  final double progress;

  ProgressRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 10.0;

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = Colors.white.withOpacity(0.2);
    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [
          Color(0xFF0864A6),
          Color(0xFF55E4EC),
          Color(0xFF37A8AE),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(ProgressRingPainter oldDelegate) => oldDelegate.progress != progress;
}

class ConstellationPainter extends CustomPainter {
  final List<_Star> stars;
  final Offset? cometStartPosition;
  final Offset? cometEndPosition;
  final double cometProgress;

  ConstellationPainter({
    required this.stars,
    this.cometStartPosition,
    this.cometEndPosition,
    required this.cometProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var star in stars) {
      paint.color = Color(0xFFB4A0D8).withOpacity(star.baseOpacity * star.controller.value);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }

    if (cometStartPosition != null && cometEndPosition != null) {
      final currentPosition = Offset(
        cometStartPosition!.dx + (cometEndPosition!.dx - cometStartPosition!.dx) * cometProgress,
        cometStartPosition!.dy + (cometEndPosition!.dy - cometStartPosition!.dy) * cometProgress,
      );

      paint.color = Colors.white.withOpacity(0.8 * (1 - cometProgress));
      paint.strokeWidth = 2;
      paint.style = PaintingStyle.stroke;
      final tailLength = 20.0 * (1 - cometProgress);
      final tailEnd = Offset(
        currentPosition.dx - tailLength * cos(pi / 4),
        currentPosition.dy - tailLength * sin(pi / 4),
      );
      canvas.drawLine(currentPosition, tailEnd, paint);

      paint.style = PaintingStyle.fill;
      canvas.drawCircle(currentPosition, 3, paint);
    }
  }

  @override
  bool shouldRepaint(ConstellationPainter oldDelegate) =>
      oldDelegate.cometProgress != cometProgress ||
      oldDelegate.cometStartPosition != cometStartPosition ||
      oldDelegate.cometEndPosition != cometEndPosition ||
      stars.any((star) => star.controller.value != oldDelegate.stars[stars.indexOf(star)].controller.value);
}

class _Star {
  final double x;
  final double y;
  final double size;
  final double baseOpacity;
  final AnimationController controller;

  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.baseOpacity,
    required this.controller,
  });
}