import 'package:flutter/material.dart';

void main() {
  runApp(const DownDatingApp());
}

class DownDatingApp extends StatelessWidget {
  const DownDatingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DownDating',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'SF Pro Display',
      ),
      home: const MobileContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Mobile phone container for web preview
class MobileContainer extends StatelessWidget {
  const MobileContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Container(
          width: 375, // iPhone width
          height: 812, // iPhone height
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 25, 25, 25),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey[700]!, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _textAnimationController;
  late AnimationController _logoShrinkController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _logoSizeAnimation;
  late Animation<Offset> _logoPositionAnimation;
  
  bool _showLoginForm = false;
  bool _startTextAnimation = false;
  bool _animationComplete = false;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000), // 3 seconds for smooth left-to-right animation
      vsync: this,
    );

    _logoShrinkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));

    // Logo size: from large (150) to medium (80) - not too small
    _logoSizeAnimation = Tween<double>(
      begin: 150.0,
      end: 80.0,
    ).animate(CurvedAnimation(
      parent: _logoShrinkController,
      curve: Curves.easeInOut,
    ));

    // Logo position: from center to just a little up (not disappearing)
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),     // Center
      end: const Offset(0.0, -0.8),      // Just slightly up, not too much!
    ).animate(CurvedAnimation(
      parent: _logoShrinkController,
      curve: Curves.easeOutCubic,
    ));
    
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // Wait 2 seconds, then start text animation
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _startTextAnimation = true;
    });
    _textAnimationController.forward();
    
    // After text animation completes, shrink logo and move to hub
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _animationComplete = true;
    });
    _logoShrinkController.forward();
    
    // Show login form after logo moves
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      _showLoginForm = true;
    });
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _textAnimationController.dispose();
    _logoShrinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: Stack(
        children: [
          // Main logo and text - initially centered, then moves to hub
          AnimatedBuilder(
            animation: Listenable.merge([_logoSizeAnimation, _logoPositionAnimation]),
            builder: (context, child) {
              return SlideTransition(
                position: _logoPositionAnimation,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo - starts large and centered, shrinks and moves to hub
                      AnimatedBuilder(
                        animation: _logoSizeAnimation,
                        builder: (context, child) {
                          return SizedBox(
                            width: _logoSizeAnimation.value,
                            height: _logoSizeAnimation.value,
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
                      
                      // Only show text during initial phase
                      if (!_animationComplete) ...[
                        const SizedBox(height: 32),
                        // DownDating Text - "Down" stays white, "Dating" animates right to left
                        AnimatedBuilder(
                          animation: _textAnimation,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: DownDatingTextPainter(_textAnimation.value),
                              size: const Size(250, 40),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Login form that slides up from bottom
          if (_showLoginForm)
            SlideTransition(
              position: _slideAnimation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Continue with Instagram button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Continue with ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFF58529),
                                      Color(0xFFDD2A7B),
                                      Color(0xFF8134AF),
                                      Color(0xFF515BD4),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                              const Text(
                                ' Instagram',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Use Phone Number
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Use Phone Number',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Divider with "Already a Member?"
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Already a\nMember?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Sign in text
                      RichText(
                        text: const TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Terms and Privacy
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Terms of use',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 40),
                          Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Custom painter for DownDating text - "Down" stays white, "Dating" animates right to left
class DownDatingTextPainter extends CustomPainter {
  final double animationValue;
  
  DownDatingTextPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    
    // "Down" - always white (never changes)
    TextPainter downPainter = TextPainter(
      text: const TextSpan(
        text: 'Down',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    downPainter.layout();
    
    // "Dating" - animated from white to red (RIGHT to LEFT)
    String datingText = 'Dating';
    List<String> letters = datingText.split('');
    
    double downWidth = downPainter.width;
    
    // Calculate total width of "DownDating" to center it
    TextPainter totalTextPainter = TextPainter(
      text: const TextSpan(
        text: 'DownDating',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    totalTextPainter.layout();
    
    // Start position to center the entire text
    double startX = centerX - (totalTextPainter.width / 2);
    
    // Paint "Down" - always white
    downPainter.paint(canvas, Offset(startX, 0));
    
    // Paint each letter of "Dating" with RIGHT TO LEFT animation
    double currentX = startX + downWidth;
    for (int i = 0; i < letters.length; i++) {
      // Calculate if this letter should be red based on animation progress
      // Animation goes from RIGHT to LEFT, so we reverse the index
      int reverseIndex = letters.length - 1 - i;
      double letterProgress = (animationValue * letters.length) - reverseIndex;
      letterProgress = letterProgress.clamp(0.0, 1.0);
      
      Color letterColor = Color.lerp(Colors.white, Colors.red, letterProgress)!;
      
      TextPainter letterPainter = TextPainter(
        text: TextSpan(
          text: letters[i],
          style: TextStyle(
            color: letterColor,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      letterPainter.layout();
      letterPainter.paint(canvas, Offset(currentX, 0));
      currentX += letterPainter.width - 0.5;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is! DownDatingTextPainter || 
           oldDelegate.animationValue != animationValue;
  }
}