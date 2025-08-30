import 'package:flutter/material.dart';
import 'expert_detail_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  final List<String> interests;
  
  const UserDashboardScreen({Key? key, required this.interests}) : super(key: key);

  @override
  UserDashboardScreenState createState() => UserDashboardScreenState();
}

class UserDashboardScreenState extends State<UserDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _shimmerController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shimmerAnimation;
  late PageController _merchandiseController;
  bool _isInitialized = false;
  bool _shimmerInitialized = false;

  // Sample expert data - Add your images to these paths
  final List<ExpertData> relationshipExperts = [
    ExpertData('David', 'assets/experts/david.jpg'),
    ExpertData('Lisa', 'assets/experts/lisa.jpg'),
    ExpertData('Tom', 'assets/experts/tom.jpg'),
    ExpertData('Marie', 'assets/experts/marie.jpg'),
    ExpertData('Sarah', 'assets/experts/sarah.jpg'),
    ExpertData('James', 'assets/experts/james.jpg'),
    ExpertData('Emma', 'assets/experts/emma.jpg'),
  ];

  final List<ExpertData> datingStrategyExperts = [
    ExpertData('Alex', 'assets/experts/alex.jpg'),
    ExpertData('Maya', 'assets/experts/maya.jpg'),
    ExpertData('Chris', 'assets/experts/chris.jpg'),
    ExpertData('Nina', 'assets/experts/nina.jpg'),
    ExpertData('Ryan', 'assets/experts/ryan.jpg'),
    ExpertData('Zoe', 'assets/experts/zoe.jpg'),
    ExpertData('Kevin', 'assets/experts/kevin.jpg'),
  ];

  final List<ExpertData> selfImprovementExperts = [
    ExpertData('Michael', 'assets/experts/michael.jpg'),
    ExpertData('Sofia', 'assets/experts/sofia.jpg'),
    ExpertData('Daniel', 'assets/experts/daniel.jpg'),
    ExpertData('Rachel', 'assets/experts/rachel.jpg'),
    ExpertData('Lucas', 'assets/experts/lucas.jpg'),
    ExpertData('Ava', 'assets/experts/ava.jpg'),
    ExpertData('Noah', 'assets/experts/noah.jpg'),
  ];

  final List<String> merchandiseItems = [
    'assets/merchandise/tshirt1.jpg',
    'assets/merchandise/hoodie1.jpg',
    'assets/merchandise/mug1.jpg',
    'assets/merchandise/tshirt2.jpg',
    'assets/merchandise/cap1.jpg',
    'assets/merchandise/sticker_pack.jpg',
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 3000), // Longer duration for slower start
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeIn, // Slow start, fast end
    ));

    _merchandiseController = PageController();
    
    _animationController.forward();
    
    // Mark shimmer as initialized
    setState(() {
      _shimmerInitialized = true;
      _isInitialized = true;
    });
    
    // Start shimmer animation after a delay to ensure everything is initialized
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _startShimmerAnimation();
      }
    });
    
    // Auto-scroll merchandise
    _startMerchandiseAutoScroll();
  }

  void _startShimmerAnimation() {
    if (mounted && _shimmerInitialized) {
      _shimmerController.repeat(reverse: true);
    }
  }

  void _startMerchandiseAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _merchandiseController.hasClients) {
        int currentPage = _merchandiseController.page?.round() ?? 0;
        int nextPage = (currentPage + 1) % merchandiseItems.length;
        
        _merchandiseController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ).then((_) => _startMerchandiseAutoScroll());
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shimmerController.dispose();
    _merchandiseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 35, 35, 35),
                Color.fromARGB(255, 25, 25, 25),
                Color.fromARGB(255, 20, 20, 20),
              ],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 35, 35, 35),   // Slightly lighter at top
              Color.fromARGB(255, 25, 25, 25),   // Original dark color
              Color.fromARGB(255, 20, 20, 20),   // Slightly darker at bottom
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopUserSection(),
                  _buildDecorativeLine(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildDiscoverExpertsSection(),
                  const SizedBox(height: 32),
                  _buildUpcomingEventsSection(),
                  const SizedBox(height: 32),
                  _buildMerchandiseSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopUserSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // User profile image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Container(
                color: Colors.grey[600],
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          
          const Spacer(),
          
          // Heart with count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 6),
                const Text(
                  '100',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Placeholder box
          Container(
            width: 40,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[600]!, width: 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeLine() {
    return Container(
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: CustomPaint(
        painter: BottomBorderPainter(),
        child: Container(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey[600]!, width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search,
              color: Colors.grey[400],
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search for experts',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverExpertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Discover Experts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildExpertCategory('Relationship', relationshipExperts),
        const SizedBox(height: 24),
        _buildExpertCategory('Dating Strategy', datingStrategyExperts),
        const SizedBox(height: 24),
        _buildExpertCategory('Self Improvement', selfImprovementExperts),
        const SizedBox(height: 32),
        // Single "View More Experts" section after all categories
        _buildViewMoreExpertsSection(),
      ],
    );
  }

  Widget _buildViewMoreExpertsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: GestureDetector(
          onTap: () => _viewMoreExperts(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 1.5),
              borderRadius: BorderRadius.circular(12),
              color: Colors.transparent,
            ),
            child: const Text(
              'View More Experts',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _viewMoreExperts() {
    print('View more experts - show all categories');
    // Navigate to comprehensive experts screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AllExpertsScreen(),
    //   ),
    // );
  }

  Widget _buildExpertCategory(String categoryName, List<ExpertData> experts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text and line on the same row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                categoryName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: experts.length,
            itemBuilder: (context, index) {
              return _buildExpertCard(experts[index]);
            },
          ),
        ),
      ],
    );
  }
Widget _buildExpertCard(ExpertData expert) {
  return Container(
    width: 70,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    child: GestureDetector(
      onTap: () => _navigateToExpertDetail(expert),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.brown],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                expert.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to colored containers with initials if image not found
                  return Container(
                    color: _getColorForName(expert.name),
                    child: Center(
                      child: Text(
                        expert.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            expert.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
  // Helper method to generate different colors for different names
  Color _getColorForName(String name) {
    final colors = [
      Colors.red[400]!,
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.purple[400]!,
      Colors.orange[400]!,
      Colors.teal[400]!,
      Colors.pink[400]!,
    ];
    return colors[name.hashCode % colors.length];
  }

  Widget _buildUpcomingEventsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Latest Upcoming Event',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF7B68EE)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '28 July\n2024',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Offline',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'DownDating Live Show',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Beth University New York',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'Mon Ground',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
void _navigateToExpertDetail(ExpertData expert) {
  // Determine category based on which list the expert belongs to
  String category = '';
  if (relationshipExperts.contains(expert)) {
    category = 'Relationship';
  } else if (datingStrategyExperts.contains(expert)) {
    category = 'Dating Strategy';
  } else if (selfImprovementExperts.contains(expert)) {
    category = 'Self Improvement';
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ExpertDetailScreen(
        expertName: expert.name,
        expertImage: expert.imagePath,
        category: category,
      ),
    ),
  );
}

  Widget _buildMerchandiseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              const Text(
                'Grab Our ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _shimmerInitialized
                  ? AnimatedBuilder(
                      animation: _shimmerAnimation,
                      builder: (context, child) {
                        return ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment(_shimmerAnimation.value - 0.3, 0),
                              end: Alignment(_shimmerAnimation.value + 0.3, 0),
                              colors: [
                                Colors.white,
                                Colors.red,
                                Colors.redAccent,
                                Colors.red,
                                Colors.white,
                              ],
                              stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                            ).createShader(bounds);
                          },
                          child: const Text(
                            'Merchandise',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    )
                  : const Text(
                      'Merchandise',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _merchandiseController,
            itemCount: merchandiseItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _navigateToMerchandiseDetail(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      merchandiseItems[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if image doesn't load
                        return Container(
                          color: Colors.grey[600],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_bag,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _getMerchandiseName(index),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
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
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'Grab our merchandise from Shopify 🌿',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToMerchandiseDetail(int index) {
    print('Navigate to merchandise item $index');
    // Navigate to merchandise detail page
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => MerchandiseDetailScreen(itemIndex: index),
    //   ),
    // );
  }

  String _getMerchandiseName(int index) {
    const names = [
      'T-Shirt 1',
      'Hoodie',
      'Coffee Mug',
      'T-Shirt 2',
      'Cap',
      'Sticker Pack',
    ];
    return names[index % names.length];
  }
}

class ExpertData {
  final String name;
  final String imagePath;

  ExpertData(this.name, this.imagePath);
}

// Reuse the same BottomBorderPainter from the interests screen
class BottomBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final shadowPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    
    path.moveTo(0, 0);
    path.quadraticBezierTo(2, size.height * 0.3, 5, size.height * 0.6);
    path.quadraticBezierTo(10, size.height * 0.9, 25, size.height - 1.5);
    path.lineTo(size.width - 25, size.height - 1.5);
    path.quadraticBezierTo(size.width - 10, size.height * 0.9, size.width - 5, size.height * 0.6);
    path.quadraticBezierTo(size.width - 2, size.height * 0.3, size.width, 0);
    path.quadraticBezierTo(size.width - 3, size.height * 0.3, size.width - 6, size.height * 0.6);
    path.quadraticBezierTo(size.width - 11, size.height * 0.9, size.width - 25, size.height + 1.5);
    path.lineTo(25, size.height + 1.5);
    path.quadraticBezierTo(11, size.height * 0.9, 6, size.height * 0.6);
    path.quadraticBezierTo(3, size.height * 0.3, 0, 0);
    path.close();
    
    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}