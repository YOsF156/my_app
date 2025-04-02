import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

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
    isFirstSession = ModalRoute.of(context)?.settings.arguments as bool? ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;
    final userProvider = Provider.of<UserProvider>(context);
    final currentDay = userProvider.currentDay ?? 1;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'Session',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '$currentDay/30',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: primaryColor,
        child: Stack(
          children: [
            // Background ellipse top left
            Positioned(
              top: -40,
              left: -40,
              child: _buildSvgWithErrorHandling(
                'assets/images/session/ellipse_35_top.svg',
                width: 162,
              ),
            ),
            
            // Background ellipse bottom left
            Positioned(
              bottom: 0,
              left: 0,
              child: _buildSvgWithErrorHandling(
                'assets/images/session/ellipse_37.svg',
                width: 180,
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
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        isFirstSession ?? false
                            ? 'Charlotte Bronte said, "A restless mind creates a restless pillow" SleepReset helps to clear your mind and optimize your sleep.\nBefore we begin, please connect your earphones, make sure that you are in a quiet comfortable place and can\'t be disturbed for the next few minutes'
                            : 'Before we begin, please connect your earphones, make sure that you are in a quiet comfortable place and can\'t be disturbed for the next few minutes.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Man illustration in the middle
                    Expanded(
                      child: _buildSvgWithErrorHandling(
                        'assets/images/session/man_illustration.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Begin session button
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFD56CFF), Color(0xFFF3B775)],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          _showHeadphoneReminder(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'BEGIN SESSION',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                letterSpacing: 0.16,
                              ),
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

  Widget _buildSvgWithErrorHandling(String assetName, {double? width, BoxFit? fit}) {
    try {
      return SvgPicture.asset(
        assetName,
        width: width,
        fit: fit ?? BoxFit.none,
        placeholderBuilder: (BuildContext context) => Container(
          width: width,
          height: width != null ? width * 0.8 : 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    } catch (e) {
      print('Error loading SVG: $e');
      // Return an empty container if loading fails
      return Container();
    }
  }

  void _showHeadphoneReminder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('SleepReset',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  )),
              SizedBox(height: 8),
              Text(
                'SleepReset works best when used with earphones, otherwise, you may significantly reduce your results.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure you want to continue?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32),
                    ),
                    child: Text(
                      'NO',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/session');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32),
                    ),
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

