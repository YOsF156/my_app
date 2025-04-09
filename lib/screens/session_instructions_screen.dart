import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/gradient_button.dart';
import 'dart:math';

class SessionInstructionsScreen extends StatefulWidget {
  @override
  _SessionInstructionsScreenState createState() =>
      _SessionInstructionsScreenState();
}

class _SessionInstructionsScreenState extends State<SessionInstructionsScreen>
    with TickerProviderStateMixin {
  bool? isFirstSession;
  final Random _random = Random();
  final List<_Star> _stars = [];

  @override
  void initState() {
    super.initState();
    // Initialize stars with individual flashing controllers
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isFirstSession = ModalRoute.of(context)?.settings.arguments as bool? ?? true;
  }

  @override
  void dispose() {
    for (var star in _stars) {
      star.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    final currentDay = userProvider.currentDay ?? 1;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            '<',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Column(
          children: [
            Text(
              'Session',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$currentDay',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: '/30',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A1965), Color(0xFF32254B)],
          ),
        ),
        child: Stack(
          children: [
            // Stars background
            CustomPaint(
              painter: ConstellationPainter(stars: _stars),
              size: Size.infinite,
            ),
            // Background ellipse top left
            Positioned(
              top: -40,
              left: -40,
              child: _buildSvgWithErrorHandling(
                'assets/images/session/ellipse_35_top.svg',
                width: 200,
              ),
            ),
            // Background ellipse bottom left
            Positioned(
              bottom: 0,
              left: 0,
              child: _buildSvgWithErrorHandling(
                'assets/images/session/ellipse_37.svg',
                width: 200,
              ),
            ),
            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Welcome text
                    Text(
                      isFirstSession ?? false
                          ? 'Welcome to your first SleepReset session'
                          : 'Welcome back to SleepReset',
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Instructions text
                    Text(
                      isFirstSession ?? false
                          ? 'Charlotte Bronte said, "A restless mind creates a restless pillow" SleepReset helps to clear your mind and optimize your sleep.\nBefore we begin, please connect your earphones, make sure that you are in a quiet comfortable place and can\'t be disturbed for the next few minutes'
                          : 'Before we begin, please connect your earphones, make sure that you are in a quiet comfortable place and can\'t be disturbed for the next few minutes.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.6),
                          ),
                      textAlign: TextAlign.center,
                    ),
                    // Man illustration in the middle
                    Expanded(
                      child: _buildSvgWithErrorHandling(
                        'assets/images/session/man_illustration.svg',
                        fit: BoxFit.contain,
                        semanticsLabel: 'Man with earphones illustration',
                      ),
                    ),
                    // Begin session button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: GradientButton(
                        text: 'BEGIN SESSION',
                        onTap: () {
                          _showHeadphoneReminder(context);
                        },
                        textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 14,
                              letterSpacing: 0.16,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSvgWithErrorHandling(String assetName, {double? width, BoxFit? fit, String? semanticsLabel}) {
    try {
      return SvgPicture.asset(
        assetName,
        width: width,
        fit: fit ?? BoxFit.none,
        semanticsLabel: semanticsLabel,
        colorFilter: null,
        placeholderBuilder: (BuildContext context) => Container(
          width: width,
          height: width != null ? width * 0.8 : 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    } catch (e) {
      print('Error loading SVG: $e');
      return Container();
    }
  }

  void _showHeadphoneReminder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Transparent to show the gradient
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2A1965), Color(0xFF32254B)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Stack(
            children: [
              // Purple star (top left)
              Positioned(
                top: 10,
                left: 10,
                child: _buildSvgWithErrorHandling(
                  'assets/images/purple_star.svg',
                  width: 30,
                ),
              ),
              // Ellipse 35 top (top right, mirrored)
              Positioned(
                top: -40,
                right: -40,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(-1.0, 1.0), // Mirror horizontally
                  child: _buildSvgWithErrorHandling(
                    'assets/images/session/ellipse_35_top.svg',
                    width: 200,
                  ),
                ),
              ),
              // Yellow star (bottom right)
              Positioned(
                bottom: 20,
                right: 20,
                child: _buildSvgWithErrorHandling(
                  'assets/images/yellow_star.svg',
                  width: 30,
                ),
              ),
              // Ellipse 37 (bottom left)
              Positioned(
                bottom: 0,
                left: 0,
                child: _buildSvgWithErrorHandling(
                  'assets/images/session/ellipse_37.svg',
                  width: 200,
                ),
              ),
              // Main content
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Rectangle up SVG
                    _buildSvgWithErrorHandling(
                      'assets/images/rectangle_up.svg',
                      width: 40,
                    ),
                    SizedBox(height: 8),
                    // SleepReset title
                    Text(
                      'SleepReset',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // White color
                          ),
                    ),
                    SizedBox(height: 16),
                    // Earphones SVGs
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildSvgWithErrorHandling(
                          'assets/images/earphones_ellipse.svg',
                          width: 60,
                        ),
                        _buildSvgWithErrorHandling(
                          'assets/images/earphones.svg',
                          width: 40,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Instructions text
                    Text(
                      'SleepReset works best when used with earphones, otherwise, you may significantly reduce your results.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                    ),
                    SizedBox(height: 10),
                    // Question text
                    Text(
                      'Are you sure you want to continue?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 14, // Same font size, not bold
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    SizedBox(height: 20),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // NO button (purple with gradient border)
                        Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              style: BorderStyle.solid,
                              color: Colors.transparent,
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFFD56CFF), Color(0xFFF3B775)],
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(2), // Margin to create border effect
                            decoration: BoxDecoration(
                              color: Color(0xFF2A1965), // Purple background
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'NO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // YES button (GradientButton, smaller)
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: GradientButton(
                            text: 'YES',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/session');
                            },
                            textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontSize: 14,
                                  letterSpacing: 0.16,
                                ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ConstellationPainter extends CustomPainter {
  final List<_Star> stars;

  ConstellationPainter({required this.stars});

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
  }

  @override
  bool shouldRepaint(ConstellationPainter oldDelegate) =>
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