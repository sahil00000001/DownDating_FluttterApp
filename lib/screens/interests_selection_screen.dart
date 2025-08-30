import 'package:flutter/material.dart';
import 'user_dashboard_screen.dart';

class InterestsSelectionScreen extends StatefulWidget {
  const InterestsSelectionScreen({Key? key}) : super(key: key);

  @override
  InterestsSelectionScreenState createState() => InterestsSelectionScreenState();
}

class InterestsSelectionScreenState extends State<InterestsSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isInitialized = false;

  // Interest items with icons
  final List<InterestItem> interests = [
    InterestItem('Photography', Icons.photo_camera_outlined),
    InterestItem('Shopping', Icons.shopping_bag_outlined),
    InterestItem('Karaoke', Icons.mic_outlined),
    InterestItem('Yoga', Icons.self_improvement_outlined),
    InterestItem('Cooking', Icons.restaurant_outlined),
    InterestItem('Tennis', Icons.sports_tennis_outlined),
    InterestItem('Run', Icons.directions_run_outlined),
    InterestItem('Swimming', Icons.pool_outlined),
    InterestItem('Art', Icons.palette_outlined),
    InterestItem('Traveling', Icons.flight_outlined),
    InterestItem('Extreme', Icons.sports_handball_outlined),
    InterestItem('Music', Icons.music_note_outlined),
    InterestItem('Drink', Icons.wine_bar_outlined),
    InterestItem('Video games', Icons.sports_esports_outlined),
  ];

  Set<int> selectedInterests = {};

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    
    // Mark as initialized after animations are set up
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get isFormValid {
    return selectedInterests.isNotEmpty; // At least one interest selected
  }

  void _toggleInterest(int index) {
    setState(() {
      if (selectedInterests.contains(index)) {
        selectedInterests.remove(index);
      } else {
        selectedInterests.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Return loading indicator if animations aren't initialized yet
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 25, 25, 25),
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Icon bar with bottom border line
              Container(
                height: 70, // Increased to accommodate shadow
                child: Stack(
                  children: [
                    // White line as bottom border with curved corners
                    Positioned(
                      bottom: 0,
                      left: 0,  // Touch screen edge
                      right: 0, // Touch screen edge
                      child: CustomPaint(
                        painter: BottomBorderPainter(),
                        child: Container(height: 20),
                      ),
                    ),
                    // Icon bar on top
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: interests.map((interest) {
                            int index = interests.indexOf(interest);
                            bool isSelected = selectedInterests.contains(index);
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected 
                                    ? Colors.red.withOpacity(0.2) 
                                    : Colors.black.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(isSelected ? 0.5 : 0.2),
                                      blurRadius: isSelected ? 8 : 4,
                                      spreadRadius: isSelected ? 2 : 1,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  interest.icon,
                                  color: isSelected ? Colors.red : Colors.red.withOpacity(0.9),
                                  size: 20,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Title section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const Text(
                      'Your interests',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Select a few of your interests and let everyone\nknow what you\'re passionate about.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Interest selection grid - 2 columns
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items per row
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3.2, // Adjust for button proportions
                    ),
                    itemCount: interests.length,
                    itemBuilder: (context, index) {
                      InterestItem interest = interests[index];
                      bool isSelected = selectedInterests.contains(index);

                      return GestureDetector(
                        onTap: () => _toggleInterest(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected 
                              ? Colors.white 
                              : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected 
                                ? Colors.white 
                                : Colors.red,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                interest.icon,
                                color: isSelected 
                                  ? Colors.black 
                                  : Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  interest.name,
                                  style: TextStyle(
                                    color: isSelected 
                                      ? Colors.black 
                                      : Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Next button
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isFormValid ? _handleNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFormValid 
                        ? Colors.white 
                        : Colors.grey[700],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 void _handleNext() {
  // Get selected interest names
  List<String> selected = selectedInterests
      .map((index) => interests[index].name)
      .toList();
  
  print('Selected interests: $selected');
  
  // Navigate to UserDashboard screen
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UserDashboardScreen(interests: selected),
    ),
  );

  }
}

class InterestItem {
  final String name;
  final IconData icon;

  InterestItem(this.name, this.icon);
}

// Custom painter for the bottom border with curved corners and tapered edges
class BottomBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Subtle shadow/glow effect
    final shadowPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

    // Main line paint
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Start from left edge - sharp point at top
    path.moveTo(0, 0);
    
    // Left curve - gradually thickening from point to full width
    path.quadraticBezierTo(
      2, size.height * 0.3,     // Thin near top
      5, size.height * 0.6,     // Getting thicker
    );
    path.quadraticBezierTo(
      10, size.height * 0.9,    // Almost full thickness
      25, size.height - 1.5,    // Full uniform thickness at bottom
    );
    
    // Straight bottom line (uniform thickness - 3px)
    path.lineTo(size.width - 25, size.height - 1.5);
    
    // Right curve - gradually thinning from full width to point
    path.quadraticBezierTo(
      size.width - 10, size.height * 0.9,  // Start decreasing
      size.width - 5, size.height * 0.6,   // Getting thinner
    );
    path.quadraticBezierTo(
      size.width - 2, size.height * 0.3,   // Very thin near top
      size.width, 0,                       // Sharp point at top
    );
    
    // Inner edge going back - right side (creating thickness)
    path.quadraticBezierTo(
      size.width - 3, size.height * 0.3,
      size.width - 6, size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width - 11, size.height * 0.9,
      size.width - 25, size.height + 1.5,  // Back to full thickness
    );
    
    // Bottom inner line (uniform thickness)
    path.lineTo(25, size.height + 1.5);
    
    // Left inner curve back to point
    path.quadraticBezierTo(
      11, size.height * 0.9,
      6, size.height * 0.6,
    );
    path.quadraticBezierTo(
      3, size.height * 0.3,
      0, 0,  // Back to sharp point
    );
    
    path.close();
    
    // Draw subtle shadow
    canvas.drawPath(path, shadowPaint);
    
    // Draw main white line
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}