import 'package:flutter/material.dart';
import 'personal_info_flow.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({Key? key}) : super(key: key);

  @override
  NameScreenState createState() => NameScreenState();
}

class NameScreenState extends State<NameScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    super.dispose();
  }

  bool get isFormValid {
    return firstNameController.text.trim().isNotEmpty && 
           lastNameController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          const SizedBox(height: 60),
          
          // User icon - Centered and Large
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 90, // Much larger
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Title - Left aligned and larger
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'My name is',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36, // Increased from 28
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Input fields with reduced width - Left aligned
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Column(
                children: [
                  // First Name Input
                  _buildInputField(
                    controller: firstNameController,
                    focusNode: firstNameFocus,
                    label: 'First name',
                    onSubmitted: (_) => lastNameFocus.requestFocus(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Last Name Input
                  _buildInputField(
                    controller: lastNameController,
                    focusNode: lastNameFocus,
                    label: 'Last name',
                    onSubmitted: (_) {
                      if (isFormValid) {
                        _handleNext();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const Spacer(),
          
          // Next button - Full width of screen
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: AnimatedBuilder(
              animation: Listenable.merge([firstNameController, lastNameController]),
              builder: (context, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isFormValid ? _handleNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFormValid ? Colors.white : Colors.grey[700],
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
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    Function(String)? onSubmitted,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, focusNode]),
      builder: (context, child) {
        bool hasText = controller.text.isNotEmpty;
        bool isFocused = focusNode.hasFocus;
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
                  controller: controller,
                  focusNode: focusNode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 8,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: onSubmitted,
                  textInputAction: label.contains('First') 
                      ? TextInputAction.next 
                      : TextInputAction.done,
                ),
              ),
              
              // Floating Label - On the border when active
              if (shouldFloat)
                Positioned(
                  left: 12,
                  top: -2, // Moved up a bit
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    color: const Color.fromARGB(255, 25, 25, 25), // Background color to hide border line
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: hasText ? Colors.red : Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      child: Text(label),
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
                      label,
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
    // Store the data or pass it to the flow controller
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    
    print('Name entered: $firstName $lastName');
    
    // Navigate to next screen
    final flowState = context.findAncestorStateOfType<PersonalInfoFlowState>();
    flowState?.nextScreen();
  }
}