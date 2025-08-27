import 'package:flutter/material.dart';
import 'name_screen.dart';
import 'gender_screen.dart';
import 'dob_screen.dart';
import 'time_of_birth_screen.dart';
import 'location_screen.dart';
import 'looking_to_date_screen.dart';
import 'upload_images_screen.dart';

class PersonalInfoFlow extends StatefulWidget {
  const PersonalInfoFlow({Key? key}) : super(key: key);

  @override
  PersonalInfoFlowState createState() => PersonalInfoFlowState();
}

class PersonalInfoFlowState extends State<PersonalInfoFlow>
    with TickerProviderStateMixin {
  int currentScreen = 0;
  PageController pageController = PageController();

  // Animation controllers for emoji transitions
  late AnimationController _emojiController;
  late Animation<double> _emojiAnimation;

  // Screen data
  final List<Map<String, dynamic>> screenData = [
    {'emoji': '✍️', 'screen': const NameScreen()},
    {'emoji': '🚻', 'screen': const GenderScreen()},
    {'emoji': '🎂', 'screen': const DobScreen()},
    {'emoji': '⏰', 'screen': const TimeOfBirthScreen()},
    {'emoji': '📍', 'screen': const LocationScreen()},
    {'emoji': '❤️', 'screen': const LookingToDateScreen()},
    {'emoji': '🖼️', 'screen': const UploadImagesScreen()},
  ];

  @override
  void initState() {
    super.initState();

    _emojiController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _emojiAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _emojiController,
      curve: Curves.easeInOut,
    ));

    _emojiController.forward();
  }

  @override
  void dispose() {
    pageController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  void nextScreen() {
    if (currentScreen < screenData.length - 1) {
      jumpToScreen(currentScreen + 1);
    } else {
      // Handle completion or navigate to next flow
      print('Personal info flow completed!');
    }
  }

  void previousScreen() {
    if (currentScreen > 0) {
      jumpToScreen(currentScreen - 1);
    }
  }

  void jumpToScreen(int targetScreen) {
    if (targetScreen >= 0 &&
        targetScreen < screenData.length &&
        targetScreen != currentScreen) {
      _emojiController.reset();
      setState(() {
        currentScreen = targetScreen;
      });

      pageController.animateToPage(
        targetScreen,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

      _emojiController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator with dots and emojis
            _buildProgressIndicator(),

            // Screen content
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) {
                  // Only update state if this wasn't triggered by our own navigation
                  if (index != currentScreen) {
                    _emojiController.reset();
                    setState(() {
                      currentScreen = index;
                    });
                    _emojiController.forward();
                  }
                },
                itemCount: screenData.length,
                itemBuilder: (context, index) {
                  return screenData[index]['screen'];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(screenData.length, (index) {
          bool isActive = index == currentScreen;
          bool isCompleted =
              index < currentScreen; // Screens that have been completed

          return GestureDetector(
            onTap: () => jumpToScreen(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 40 : 8,
              height: isActive ? 40 : 8,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.transparent
                    : (isCompleted ? Colors.white : Colors.grey[600]),
                borderRadius: BorderRadius.circular(isActive ? 20 : 4),
                border:
                    isActive ? Border.all(color: Colors.white, width: 2) : null,
              ),
              child: isActive
                  ? Center(
                      child: AnimatedBuilder(
                        animation: _emojiAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _emojiAnimation.value,
                            child: Text(
                              screenData[index]['emoji'],
                              style: const TextStyle(fontSize: 24),
                            ),
                          );
                        },
                      ),
                    )
                  : (isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Color.fromARGB(255, 25, 25, 25),
                          size: 6,
                        )
                      : null),
            ),
          );
        }),
      ),
    );
  }
}
