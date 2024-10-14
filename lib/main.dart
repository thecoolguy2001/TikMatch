import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(TikMatchApp());
}

class TikMatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TikMatchHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TikMatchHomePage extends StatefulWidget {
  @override
  _TikMatchHomePageState createState() => _TikMatchHomePageState();
}

class _TikMatchHomePageState extends State<TikMatchHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _lavaLampController;
   bool isCardFlipped = false;
  final List<String> kathyImages = [
    'https://via.placeholder.com/400x500', // Replace with actual images for Kathy
    'https://via.placeholder.com/400x500/FFB6C1',
    'https://via.placeholder.com/400x500/87CEFA',
  ];
  int topCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _lavaLampController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // Lava lamp effect speed
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _lavaLampController.dispose();
    super.dispose();
  }

  // Shuffle Cards (Top to Back)
  void _shuffleCards() {
    setState(() {
      topCardIndex = (topCardIndex + 1) % kathyImages.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Dynamic Lava Lamp Background
          AnimatedBuilder(
            animation: _lavaLampController,
            builder: (context, child) {
              return CustomPaint(
                painter: LavaLampPainter(_lavaLampController.value),
                child: Container(),
              );
            },
          ),
          Column(
  children: [
    // Header
    Padding(
      padding: const EdgeInsets.only(top: 80.0,left: 25.0, right: 25.0), // Move the header down
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.notifications, color: Colors.white),
          Text(
            "TikMatch Business",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          Icon(Icons.settings, color: Colors.white),
        ],
      ),
    ),
    
    Spacer(flex: 1),  // Adds a flexible space between header and cards
    // Card stack with details always visible
    GestureDetector(
      onTap: _shuffleCards,
      child: Center(
        child: Container(
          height: 500.0,
          width: 400.0,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(kathyImages.length, (index) {
              int position = (topCardIndex + index) % kathyImages.length;
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                top: index * 5.0,
                child: Transform.rotate(
                  angle: position == topCardIndex ? 0 : -0.05 + index * 0.02,
                  child: _buildProfileCard(kathyImages[position]),
                ),
              );
            }).reversed.toList(),
          ),
        ),
      ),
    ),
    Spacer(flex: 2),  // Adds a flexible space below the cards, if needed
  ],
),

          // Bottom Navigation Bar
          Positioned(
  bottom: 50,  // Adjusted for more spacing above the bottom of the screen
  left: 0,
  right: 0,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // Space icons evenly across the screen
    children: [
      _buildNavButton(Icons.favorite_border),
      _buildNavButton(Icons.home),
      _buildNavButton(Icons.person_outline),
    ],
  ),
),
        ],
      ),
    );
  }

  // Profile Card UI with Kathy details
 Widget _buildProfileCard(String imageUrl) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCardFlipped = !isCardFlipped;
        });
      },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 600),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotate = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            child: child,
            builder: (context, child) {
              final angle = rotate.value;
              if (angle >= pi / 2) {
                return Transform(
                  transform: Matrix4.identity()..rotateY(-pi),
                  alignment: Alignment.center,
                  child: child,
                );
              } else {
                return Transform(
                  transform: Matrix4.identity()..rotateY(angle),
                  alignment: Alignment.center,
                  child: child,
                );
              }
            },
          );
        },
        child: isCardFlipped ? _buildBackCardContent() : _buildFrontCardContent(imageUrl),
      ),
    );
  }

  // Front content of the card
  Widget _buildFrontCardContent(String imageUrl) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 300.0, // Fixed width based on the wireframe
        height: 500.0, // Fixed height based on the wireframe
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Profile Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,  // Ensure image fills the card properly
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            // Kathy Details (Visible on all cards)
            Positioned(
              top: 20,
              left: 20,
              child: Text(
                "Kathy",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isCardFlipped = !isCardFlipped;
                  });
                },
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Back content of the card
  Widget _buildBackCardContent() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 300.0,
        height: 500.0,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Angela",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text("@angelastudio", style: TextStyle(fontSize: 18)),
            Text("Atlanta, GA", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Movie Producer", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
              "Common Interests: Film-making, Marketing, Branding, and Film History",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Message:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Hello! Looking for people in the movie industry to connect with. I have worked with various studios and would like to connect with others!",
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text("View Tiktok Page"),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Navigation Button UI
 Widget _buildNavButton(IconData icon) {
  return Container(
    width: 70,  // Adjusted width for larger circle
    height: 70,  // Adjusted height for larger circle
    decoration: BoxDecoration(
      color: Colors.transparent,  // Transparent background for circles
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.white,  // White border color
        width: 3,  // Adjusted border thickness for emphasis
      ),
    ),
    child: Center(
      child: Icon(
        icon,
        color: Colors.white,
        size: 35,  // Larger icon size
      ),
    ),
  );
}
}

// Custom Painter for Dynamic Lava Lamp Effect
class LavaLampPainter extends CustomPainter {
  final double animationValue;

  LavaLampPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 0, 253, 236) // Define a single color for all blobs.
      ..style = PaintingStyle.fill;

    // Draw two large circular blobs
    _drawCircularBlob(
      canvas,
      size,
      paint,
      offsetX: size.width * 0.3,  // Blob positioned closer to top-left
      offsetY: size.height * 0.3,
      radius: 180 + sin(animationValue * pi * 2) * 40,  // Radius changes slightly with motion
    );

    _drawCircularBlob(
      canvas,
      size,
      paint,
      offsetX: size.width * 0.7,  // Blob positioned towards center-right
      offsetY: size.height * 0.5,
      radius: 160 + cos(animationValue * pi * 2) * 30,  // Radius changes slightly with motion
    );
  }

  // Helper function to draw a single circular blob with smooth edges
  void _drawCircularBlob(
    Canvas canvas,
    Size size,
    Paint paint, {
    required double offsetX,
    required double offsetY,
    required double radius,
  }) {
    Path path = Path();

    // Create a circular path that smoothly animates
    path.addOval(Rect.fromCircle(center: Offset(offsetX, offsetY), radius: radius));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
