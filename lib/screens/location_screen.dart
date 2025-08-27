import 'package:flutter/material.dart';
import 'personal_info_flow.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final TextEditingController locationController = TextEditingController();
  final FocusNode locationFocus = FocusNode();

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    locationController.dispose();
    locationFocus.dispose();
    super.dispose();
  }

  bool get isFormValid {
    return locationController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            const SizedBox(height: 60),

            // Location icon - Centered and Large
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                  size: 90,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Title - Left aligned and larger
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'You live around',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Location input field - Left aligned
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 320),
                child: _buildLocationField(),
              ),
            ),

            const Spacer(),

            // Next button
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: AnimatedBuilder(
                animation: locationController,
                builder: (context, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isFormValid ? _handleNext : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isFormValid ? Colors.white : Colors.grey[700],
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return AnimatedBuilder(
      animation: Listenable.merge([locationController, locationFocus]),
      builder: (context, child) {
        bool hasText = locationController.text.isNotEmpty;
        bool isFocused = locationFocus.hasFocus;
        bool shouldFloat = hasText || isFocused;

        return Container(
          height: 60,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Stack(
            children: [
              // Input Field Container
              Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: shouldFloat
                        ? (hasText ? Colors.red : Colors.white)
                        : Colors.grey[600]!,
                    width: shouldFloat ? 2 : 1,
                  ),
                ),
                child: TextField(
                  controller: locationController,
                  focusNode: locationFocus,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                      left: 16,
                      right: 50, // Space for globe icon
                      top: 16,
                      bottom: 8,
                    ),
                    suffixIcon: Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.public,
                        color: Colors.grey[400],
                        size: 24,
                      ),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) {
                    if (isFormValid) {
                      _handleNext();
                    }
                  },
                ),
              ),

              // Floating Label - On the border when active
              if (shouldFloat)
                Positioned(
                  left: 12,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    color: const Color.fromARGB(255, 25, 25, 25),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: hasText ? Colors.red : Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      child: const Text('Location'),
                    ),
                  ),
                ),

              // Placeholder Label - Inside when not focused/empty
              if (!shouldFloat)
                Positioned(
                  left: 16,
                  top: 18,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: shouldFloat ? 0.0 : 1.0,
                    child: Text(
                      'Location',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _handleNext() {
    final location = locationController.text.trim();
    print('Location entered: $location');

    // Navigate to next screen
    final flowState = context.findAncestorStateOfType<PersonalInfoFlowState>();
    flowState?.nextScreen();
  }
}
