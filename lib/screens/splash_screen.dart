import 'package:flutter/material.dart';
import 'EnterYourPhoneNumber.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation controllers for the new sequence
  late AnimationController _logoFadeController;
  late AnimationController _titleController;
  late AnimationController _logoMoveController;
  late AnimationController _loginFormController;

  // Logo fade animation
  late Animation<double> _logoFadeAnimation;

  // Title animations (including color fill)
  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<double> _colorFillAnimation; // Bring back color animation

  // Logo move up animation - less dramatic movement
  late Animation<Offset> _logoMoveAnimation;
  
  // Title move up animation - different amount than logo
  late Animation<Offset> _titleMoveAnimation;

  // Login form slide animation
  late Animation<Offset> _loginFormSlideAnimation;

  bool _showTitle = false;
  bool _showLoginForm = false;

  @override
  void initState() {
    super.initState();

    // Step 1: Logo fade-in controller (0.8-1s)
    _logoFadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    // Step 2: Title entry controller (longer duration to see the slide)
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 4000), // SLOWER: Increased to 4 seconds for slower color animation
      vsync: this,
    );

    // Step 4: Logo move up controller (1-2s)
    _logoMoveController = AnimationController(
      duration: const Duration(milliseconds: 1800), // Slightly longer for smoother animation
      vsync: this,
    );

    // Step 5: Login form controller
    _loginFormController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoFadeController,
      curve: Curves.easeInOut,
    ));

    // Title fade animation - quick fade in so slide movement is visible
    _titleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: const Interval(0.0, 0.2, curve: Curves.easeIn), // Quick fade in first 20% of animation
    ));

    // Color fill animation for "Dating" text (right to left) - happens after slide
    _colorFillAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: const Interval(0.2, 1.0, curve: Curves.linear), // SLOWER: Linear for consistent speed, starts at 20% after slide
    ));

    // Title slide animation (from center to final position below logo)
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.4), // Start from logo center area
      end: const Offset(0.0, 0.0), // End at final position below logo
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOutQuart, // Even smoother curve for visible slide movement
    ));

    // Logo move up animation - less dramatic movement
    _logoMoveAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end:
          const Offset(0.0, -2.5), // Balanced upward movement
    ).animate(CurvedAnimation(
      parent: _logoMoveController,
      curve: Curves.easeInOutCubic, // Smoother curve for better animation
    ));

    // Title move up animation - moves MORE than logo to get closer
    // Adjust this value to fine-tune the final position
    _titleMoveAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -4.0), // Smooth upward movement that works with dynamic offset
    ).animate(CurvedAnimation(
      parent: _logoMoveController,
      curve: Curves.easeInOutCubic, // Same smooth curve as logo for synchronized movement
    ));

    // Login form slide animation - INITIALIZE THIS
    _loginFormSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _loginFormController,
      curve: Curves.easeInOut,
    ));

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // Step 1: Logo fade-in (0.8-1s)
    await _logoFadeController.forward();

    // Step 2: Title appears and starts color animation
    setState(() {
      _showTitle = true;
    });
    
    // Start color animation but don't wait for it to complete
    _titleController.forward();
    
    // Step 3: Wait for partial color animation (let color animation run for 2 seconds)
    await Future.delayed(const Duration(milliseconds: 2000));

    // Step 4: Start upward animation WHILE color is still animating
    _logoMoveController.forward(); // Don't await, let it run parallel
    
    // Wait for the upward animation to complete
    await Future.delayed(const Duration(milliseconds: 1800));

    // Step 5: Show login form
    setState(() {
      _showLoginForm = true;
    });
    _loginFormController.forward();
  }

  @override
  void dispose() {
    _logoFadeController.dispose();
    _titleController.dispose();
    _logoMoveController.dispose();
    _loginFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final safeAreaTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 25, 25, 25), // Dark background like previous
      body: Stack(
        children: [
          // Centered logo with animations - moved slightly down initially
          Center(
            child: Transform.translate(
              offset: const Offset(0, -20), // Slightly above center for better initial composition
              child: SlideTransition(
                position: _logoMoveAnimation,
                child: FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: SizedBox(
                    width: 100, // Base size like original - will be scaled larger
                    height: 100,
                    child: Transform.scale(
                      scale: 2.8, // Large scale like your original final size
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Title text below logo
          if (_showTitle)
            Center(
              child: AnimatedBuilder(
                animation: _logoMoveController,
                builder: (context, child) {
                  // Smooth interpolation for text position during upward animation
                  double dynamicOffset = 120 + (_logoMoveController.value * -80);
                  
                  return Transform.translate(
                    offset: Offset(0, dynamicOffset),
                    child: SlideTransition(
                      position: _titleMoveAnimation,
                      child: SlideTransition(
                        position: _titleSlideAnimation,
                        child: FadeTransition(
                          opacity: _titleFadeAnimation,
                          child: CustomPaint(
                            painter: DownDatingTextPainter(_colorFillAnimation.value),
                            size: const Size(250, 40),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Login form (appears after animation sequence)
          if (_showLoginForm)
            Positioned(
              left: 32,
              right: 32,
              top: screenHeight * 0.50,
              child: SlideTransition(
                position: _loginFormSlideAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Continue with Instagram button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EnterPhoneNumberScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 2,
                          shadowColor: Colors.black.withOpacity(0.1),
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

                    // Use Phone Number button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EnterPhoneNumberScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor:
                              Colors.white, // White text for dark background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          side: const BorderSide(
                            color: Colors
                                .white, // White border for dark background
                            width: 1.5,
                          ),
                        ),
                        child: const Text(
                          'Use Phone Number',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 80),

                    // Divider with "Already a Member?"
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 0.5,
                            color: Colors.grey[400],
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
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Sign in text
                    GestureDetector(
                      onTap: () {},
                      child: RichText(
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
        ],
      ),
    );
  }
}

// Custom painter for DownDating text with Right→Left color fill animation
class DownDatingTextPainter extends CustomPainter {
  final double animationValue;

  DownDatingTextPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;

    // "Down" - always white (#FFFFFF) as per spec
    TextPainter downPainter = TextPainter(
      text: const TextSpan(
        text: 'Down',
        style: TextStyle(
          color: Colors.white, // Pure white #FFFFFF
          fontSize: 48,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    downPainter.layout();

    // Calculate total width to center the entire "DownDating"
    TextPainter totalTextPainter = TextPainter(
      text: const TextSpan(
        text: 'DownDating',
        style: TextStyle(
          color: Colors.white,
          fontSize: 48,
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

    // Paint "Dating" with RIGHT → LEFT color fill animation
    String datingText = 'Dating';
    List<String> letters = datingText.split('');

    double currentX = startX + downPainter.width;
    for (int i = 0; i < letters.length; i++) {
      // RIGHT → LEFT animation: letters fill from rightmost (index 5) to leftmost (index 0)
      // Reverse the index calculation so rightmost letters fill first
      int reverseIndex = letters.length - 1 - i;
      double letterProgress = (animationValue * letters.length) - reverseIndex;
      letterProgress = letterProgress.clamp(0.0, 1.0);

      // Color lerp from white to red RGBA(255, 0, 0, 255)
      Color letterColor = Color.lerp(
          Colors.white, const Color.fromRGBO(255, 0, 0, 1.0), letterProgress)!;

      TextPainter letterPainter = TextPainter(
        text: TextSpan(
          text: letters[i],
          style: TextStyle(
            color: letterColor,
            fontSize: 48,
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