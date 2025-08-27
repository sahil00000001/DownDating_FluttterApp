import 'package:flutter/material.dart';
import 'personal_info_flow.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  GenderScreenState createState() => GenderScreenState();
}

class GenderScreenState extends State<GenderScreen>
    with TickerProviderStateMixin {
  String? selectedGender;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> genderOptions = [
    {
      'value': 'woman',
      'label': 'Woman',
      'icon': Icons.female,
      'isSelected': false,
    },
    {
      'value': 'man',
      'label': 'Man',
      'icon': Icons.male,
      'isSelected': false,
    },
    {
      'value': 'other',
      'label': 'Choose another',
      'icon': Icons.more_horiz,
      'isSelected': false,
    },
  ];

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
    super.dispose();
  }

  void _selectGender(String gender) {
    setState(() {
      selectedGender = gender;

      // Update selection status
      for (var option in genderOptions) {
        option['isSelected'] = option['value'] == gender;
      }
    });
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

            // Gender icon with animation - Centered and Large
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: selectedGender != null
                      ? Colors.white.withOpacity(0.2)
                      : Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    _getSelectedIcon(),
                    key: ValueKey(selectedGender),
                    color: Colors.white,
                    size: 90, // Much larger
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Title - Left aligned and larger
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'I am a',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36, // Increased from 28
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Gender options
            ...genderOptions.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> option = entry.value;
              bool isSelected = option['value'] == selectedGender;

              return AnimatedContainer(
                duration: Duration(milliseconds: 200 + (index * 100)),
                margin: const EdgeInsets.only(bottom: 16),
                child: _buildGenderOption(
                  value: option['value'],
                  label: option['label'],
                  icon: option['icon'],
                  isSelected: isSelected,
                ),
              );
            }).toList(),

            const Spacer(),

            // Next button
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: AnimatedOpacity(
                opacity: selectedGender != null ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: selectedGender != null ? _handleNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedGender != null
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
                        fontSize: 18, // Consistent with name screen
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption({
    required String value,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _selectGender(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey[600]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              AnimatedScale(
                scale: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            if (value == 'other' && !isSelected)
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  IconData _getSelectedIcon() {
    switch (selectedGender) {
      case 'woman':
        return Icons.female;
      case 'man':
        return Icons.male;
      case 'other':
        return Icons.more_horiz;
      default:
        return Icons.person_outline;
    }
  }

  void _handleNext() {
    print('Gender selected: $selectedGender');

    // Navigate to next screen
    final flowState = context.findAncestorStateOfType<PersonalInfoFlowState>();
    flowState?.nextScreen();
  }
}
