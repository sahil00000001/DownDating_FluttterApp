// TODO Implement this library.
import 'package:flutter/material.dart';
import 'personal_info_flow.dart';

class UploadImagesScreen extends StatefulWidget {
  const UploadImagesScreen({Key? key}) : super(key: key);

  @override
  UploadImagesScreenState createState() => UploadImagesScreenState();
}

class UploadImagesScreenState extends State<UploadImagesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<String?> uploadedImages = List.filled(6, null);
  int uploadedCount = 0;

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

  bool get isFormValid {
    return uploadedCount >= 3; // Minimum 3 images required
  }

  void _selectImage(int index) {
    // Simulate image selection
    setState(() {
      if (uploadedImages[index] == null) {
        uploadedImages[index] = 'image_$index.jpg';
        uploadedCount++;
      } else {
        uploadedImages[index] = null;
        uploadedCount--;
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

            // Photo/Cloud icon - Centered and Large
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
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
                'Show us how you look',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description - Left aligned
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Upload at minimum 3 and 6 at maximum',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Image upload grid
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 350),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return _buildImageUploadBox(index);
                  },
                ),
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0, top: 20.0),
              child: SizedBox(
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadBox(int index) {
    bool hasImage = uploadedImages[index] != null;

    return GestureDetector(
      onTap: () => _selectImage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: hasImage ? Colors.red.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: hasImage ? Colors.red : Colors.grey[600]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: hasImage
            ? Stack(
                children: [
                  // Simulated image (using a colored container)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  // Remove button
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _selectImage(index),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Colors.grey[400],
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add Photo',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _handleNext() {
    print('Images uploaded: $uploadedCount');
    print(
        'Image paths: ${uploadedImages.where((img) => img != null).toList()}');

    // This would be the end of the personal info flow
    // Navigate to completion screen or next major flow
    final flowState = context.findAncestorStateOfType<PersonalInfoFlowState>();
    flowState?.nextScreen(); // This will trigger completion logic
  }
}
