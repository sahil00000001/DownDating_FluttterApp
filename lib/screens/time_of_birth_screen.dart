import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'personal_info_flow.dart';

class TimeOfBirthScreen extends StatefulWidget {
  const TimeOfBirthScreen({Key? key}) : super(key: key);

  @override
  TimeOfBirthScreenState createState() => TimeOfBirthScreenState();
}

class TimeOfBirthScreenState extends State<TimeOfBirthScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool knowsTime = true; // Default to "I Know"
  String selectedPeriod = 'AM';

  final TextEditingController hourController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();

  final FocusNode hourFocus = FocusNode();
  final FocusNode minuteFocus = FocusNode();

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
    hourController.dispose();
    minuteController.dispose();
    hourFocus.dispose();
    minuteFocus.dispose();
    super.dispose();
  }

  bool get isFormValid {
    if (!knowsTime) return true; // If they don't know, that's valid

    return hourController.text.trim().isNotEmpty &&
        minuteController.text.trim().isNotEmpty &&
        hourController.text.trim().length <= 2 &&
        minuteController.text.trim().length == 2;
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

            // Clock icon - Centered and Large
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 90,
                ),
              ),
            ),

            const SizedBox(height: 50),

            // Title - Left aligned and larger
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Time of birth',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Know/Don't Know toggle - Improved design
            Container(
              constraints: const BoxConstraints(maxWidth: 320),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      'I Know',
                      knowsTime,
                      () => setState(() => knowsTime = true),
                    ),
                  ),
                  Expanded(
                    child: _buildToggleButton(
                      'I Don\'t Know',
                      !knowsTime,
                      () => setState(() => knowsTime = false),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Time picker section - Only show if they know
            if (knowsTime) _buildTimePickerSection(),

            const Spacer(),

            // Next button
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: AnimatedBuilder(
                animation: Listenable.merge([hourController, minuteController]),
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

  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(21),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePickerSection() {
    return AnimatedOpacity(
      opacity: knowsTime ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          children: [
            // Time display section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hour input
                  _buildTimeInput(
                    controller: hourController,
                    focusNode: hourFocus,
                    placeholder: '00',
                    maxLength: 2,
                    onSubmitted: (_) => minuteFocus.requestFocus(),
                  ),

                  // Separator
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      ':',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),

                  // Minute input
                  _buildTimeInput(
                    controller: minuteController,
                    focusNode: minuteFocus,
                    placeholder: '00',
                    maxLength: 2,
                    onSubmitted: (_) {
                      if (isFormValid) {
                        _handleNext();
                      }
                    },
                  ),

                  const SizedBox(width: 24),

                  // AM/PM selector
                  Column(
                    children: [
                      _buildPeriodSelector('AM'),
                      const SizedBox(height: 4),
                      _buildPeriodSelector('PM'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Helper text
            Text(
              'Enter your birth time in 12-hour format',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInput({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String placeholder,
    required int maxLength,
    Function(String)? onSubmitted,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, focusNode]),
      builder: (context, child) {
        bool hasText = controller.text.isNotEmpty;
        bool isFocused = focusNode.hasFocus;

        return Container(
          width: 60,
          height: 70,
          decoration: BoxDecoration(
            color: hasText || isFocused
                ? Colors.white.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasText
                  ? Colors.red
                  : (isFocused ? Colors.white : Colors.transparent),
              width: hasText || isFocused ? 2 : 0,
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
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              hintText: placeholder,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 28,
                fontWeight: FontWeight.w300,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: onSubmitted,
            onTap: () {
              if (!focusNode.hasFocus) {
                focusNode.requestFocus();
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildPeriodSelector(String period) {
    bool isSelected = selectedPeriod == period;

    return GestureDetector(
      onTap: () => setState(() => selectedPeriod = period),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 28,
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey[600]!,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            period,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _handleNext() {
    if (knowsTime) {
      final hour = hourController.text.trim();
      final minute = minuteController.text.trim();
      print('Time of birth: $hour:$minute $selectedPeriod');
    } else {
      print('Time of birth: Unknown');
    }

    // Navigate to next screen
    final flowState = context.findAncestorStateOfType<PersonalInfoFlowState>();
    flowState?.nextScreen();
  }
}
