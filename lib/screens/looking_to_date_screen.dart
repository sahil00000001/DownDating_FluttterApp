// TODO Implement this library.
import 'package:flutter/material.dart';
import 'personal_info_flow.dart';

class LookingToDateScreen extends StatefulWidget {
  const LookingToDateScreen({Key? key}) : super(key: key);

  @override
  LookingToDateScreenState createState() => LookingToDateScreenState();
}

class LookingToDateScreenState extends State<LookingToDateScreen> 
    with TickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String? selectedPreference;

  final List<Map<String, dynamic>> datingOptions = [
    {
      'value': 'woman',
      'label': 'Woman',
      'icon': Icons.female,
    },
    {
      'value': 'man',
      'label': 'Man', 
      'icon': Icons.male,
    },
    {
      'value': 'both',
      'label': 'Both',
      'icon': Icons.more_horiz,
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

  void _selectPreference(String preference) {
    setState(() {
      selectedPreference = preference;
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
            
            // Smiley face icon - Centered and Large
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mood,
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
                'You looking to date',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Dating preference options
            ...datingOptions.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> option = entry.value;
              bool isSelected = option['value'] == selectedPreference;
              
              return AnimatedContainer(
                duration: Duration(milliseconds: 200 + (index * 100)),
                margin: const EdgeInsets.only(bottom: 16),
                child: _buildDatingOption(
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
                opacity: selectedPreference != null ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: selectedPreference != null ? _handleNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedPreference != null 
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatingOption({
    required String value,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _selectPreference(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.grey[600]!,
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
                    ? Colors.black.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.black : Colors.white,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            
            if (isSelected)
              AnimatedScale(
                scale: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            
            if (value == 'both' && !isSelected)
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

  void _handleNext() {
    print('Dating preference selected: $selectedPreference');
    
    // Navigate to next screen
    final flowState = context.findAncestorStateOfType<PersonalInfoFlowState>();
    flowState?.nextScreen();
  }
}