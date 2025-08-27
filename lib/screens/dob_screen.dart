import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'personal_info_flow.dart';

class DobScreen extends StatefulWidget {
  const DobScreen({Key? key}) : super(key: key);

  @override
  DobScreenState createState() => DobScreenState();
}

class DobScreenState extends State<DobScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  final FocusNode dayFocus = FocusNode();
  final FocusNode monthFocus = FocusNode();
  final FocusNode yearFocus = FocusNode();

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
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    dayFocus.dispose();
    monthFocus.dispose();
    yearFocus.dispose();
    super.dispose();
  }

  bool get isFormValid {
    return dayController.text.trim().isNotEmpty &&
        monthController.text.trim().isNotEmpty &&
        yearController.text.trim().isNotEmpty &&
        dayController.text.trim().length == 2 &&
        monthController.text.trim().length == 2 &&
        yearController.text.trim().length == 4;
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

            // Birthday cake icon - Centered and Large
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cake,
                  color: Colors.white,
                  size: 90,
                ),
              ),
            ),

            const SizedBox(height: 50), // Increased from 30 to move title down

            // Title - Left aligned and larger
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'My DOB is',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Date picker fields - Left aligned with simplified design
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Row(
                  children: [
                    // Day field
                    Expanded(
                      flex: 2,
                      child: _buildSimpleDateField(
                        controller: dayController,
                        focusNode: dayFocus,
                        hint: 'DD',
                        maxLength: 2,
                        onSubmitted: (_) => monthFocus.requestFocus(),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Month field
                    Expanded(
                      flex: 2,
                      child: _buildSimpleDateField(
                        controller: monthController,
                        focusNode: monthFocus,
                        hint: 'MM',
                        maxLength: 2,
                        onSubmitted: (_) => yearFocus.requestFocus(),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Year field
                    Expanded(
                      flex: 3,
                      child: _buildSimpleDateField(
                        controller: yearController,
                        focusNode: yearFocus,
                        hint: 'YYYY',
                        maxLength: 4,
                        onSubmitted: (_) {
                          if (isFormValid) {
                            _handleNext();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Next button
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: AnimatedBuilder(
                animation: Listenable.merge(
                    [dayController, monthController, yearController]),
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

  Widget _buildSimpleDateField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required int maxLength,
    Function(String)? onSubmitted,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, focusNode]),
      builder: (context, child) {
        bool hasText = controller.text.isNotEmpty;
        bool isFocused = focusNode.hasFocus;

        return Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasText
                  ? Colors.red
                  : (isFocused ? Colors.white : Colors.grey[600]!),
              width: hasText || isFocused ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            maxLength: maxLength,
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: onSubmitted,
            onTap: () {
              // Ensure focus is properly set on tap
              if (!focusNode.hasFocus) {
                focusNode.requestFocus();
              }
            },
          ),
        );
      },
    );
  }

  void _handleNext() {
    final day = dayController.text.trim();
    final month = monthController.text.trim();
    final year = yearController.text.trim();

    print('DOB entered: $day/$month/$year');

    // Navigate to next screen
    final flowState = context.findAncestorStateOfType<PersonalInfoFlowState>();
    flowState?.nextScreen();
  }
}
