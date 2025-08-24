import 'package:flutter/material.dart';
import 'EnterYourPhoneNumber.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _colorFillAnimation;
  late Animation<double> _liftShrinkAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _titleScaleAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _instagramController;
  late Animation<Offset> _instagramSlideAnimation;
  late Animation<double> _instagramFadeAnimation;
  
  bool _showLoginForm = false;
  bool _showInstagramButton = false;

  @override
  void initState() {
    super.initState();
    
    // Main animation controller - total duration 1800ms for smoother timing
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    
    // Slide controller for login form
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Instagram button animation controller
    _instagramController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Phase A: Color Fill Animation (0ms - 1800ms) - Right → Left, slower & smoother
    // Interval: 0.0 to 1.0 (full duration)
    _colorFillAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOutQuad), // easeOutQuad as per spec
    ));
    
    // Phase B: Lift & Shrink Animation (400ms - 1800ms) - starts earlier for smooth motion
    // Interval: 0.222 to 1.0 (400/1800 to 1800/1800)
    _liftShrinkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.222, 1.0, curve: Curves.easeInOutCubic), // continuous smooth motion
    ));
    
    // Logo scale: 2.4 → 1.8 (huge initially, still very large finally - 25% shrink)
    _logoScaleAnimation = Tween<double>(
      begin: 3.4,
      end: 2.8,
    ).animate(_liftShrinkAnimation);
    
    // Title scale: 1.00 → 0.95  
    _titleScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(_liftShrinkAnimation);
    
    // Login form slide animation - adjusted for higher position
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3), // Start slightly below final position
      end: const Offset(0.0, 0.0),   // End at final position
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    // Instagram button slide up animation
    _instagramSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5), // Start slightly below
      end: const Offset(0.0, 0.0),   // End in final position
    ).animate(CurvedAnimation(
      parent: _instagramController,
      curve: Curves.easeOutBack, // Bouncy effect
    ));
    
    // Instagram button fade animation
    _instagramFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _instagramController,
      curve: Curves.easeOut,
    ));
    
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // Start the main animation immediately
    _mainController.forward();
    
    // Wait for main animation to complete, then show login form
    await Future.delayed(const Duration(milliseconds: 1900));
    setState(() {
      _showLoginForm = true;
    });
    _slideController.forward();
    
    // Wait for login form to appear, then animate Instagram button
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      _showInstagramButton = true;
    });
    _instagramController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _slideController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: Stack(
        children: [
          // Main header block (Logo + Title) with precise positioning
          AnimatedBuilder(
            animation: _mainController,
            builder: (context, child) {
              // Calculate exact final position: logo top edge at safe-area + 80dp (much more space above)
              final logoSize = 100 * _logoScaleAnimation.value; // Current logo size
              final finalLogoTop = safeAreaTop + 170; // Target position - generous space above
              final screenCenter = screenHeight / 2;
              
              // Calculate current position - interpolate from center to exact top position
              final currentLogoTop = screenCenter - (logoSize / 2) + 
                                   (_liftShrinkAnimation.value * (finalLogoTop - (screenCenter - logoSize / 2)));
              
              return Positioned(
                left: 0,
                right: 0,
                top: currentLogoTop,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo with scale animation - starts huge (2.4×)
                    Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: SizedBox(
                        width: 100, // Base size - scaled to 2.4× initially (240px)
                        height: 100,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    
                    // Dynamic spacing: 25% of current logo height → 20dp fixed finally
                    SizedBox(
                      height: (100 * _logoScaleAnimation.value * 0.25) * 
                             (1.0 - _liftShrinkAnimation.value) + 
                             (80 * _liftShrinkAnimation.value), // logoHeight * 0.25 → 20dp fixed
                    ),
                    
                    // Title with scale and color animation
                    Transform.scale(
                      scale: _titleScaleAnimation.value,
                      child: CustomPaint(
                        painter: DownDatingTextPainter(_colorFillAnimation.value),
                        size: const Size(250, 40),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Login form positioned much closer to DownDating title
          if (_showLoginForm)
            Positioned(
              left: 32,
              right: 32,
              top: screenHeight * 0.55, // Move much further down - more space from DownDating title
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Continue with Instagram button - with slide up animation
                    if (_showInstagramButton)
                      SlideTransition(
                        position: _instagramSlideAnimation,
                        child: FadeTransition(
                          opacity: _instagramFadeAnimation,
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const EnterPhoneNumberScreen()),
                                );
                              },
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
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Use Phone Number
                    TextButton(
                      onPressed: () {
                      },
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
                    GestureDetector(
                      onTap: () {
                      },
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

// Custom painter for DownDating text with Right→Left color fill as per updated spec
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
    
    // Paint "Dating" with RIGHT → LEFT color fill as per updated spec
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
      Color letterColor = Color.lerp(Colors.white, const Color.fromRGBO(255, 0, 0, 1.0), letterProgress)!;
      
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