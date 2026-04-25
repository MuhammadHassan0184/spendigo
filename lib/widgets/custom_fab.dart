// import 'package:flutter/material.dart';
// import 'package:spendigo/config/colors.dart';

// class CustomFAB extends StatelessWidget {
//   final VoidCallback onTap;
//   final IconData icon;

//   const CustomFAB({super.key, required this.onTap, this.icon = Icons.add});

// ignore_for_file: deprecated_member_use

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: onTap,
//       backgroundColor: AppColors.primary,
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
//       child: Icon(icon, size: 30, color: AppColors.white),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';

class CustomFAB extends StatefulWidget {
  final VoidCallback onTap;
  final IconData icon;

  const CustomFAB({super.key, required this.onTap, this.icon = Icons.add});

  @override
  State<CustomFAB> createState() => _CustomFABState();
}

class _CustomFABState extends State<CustomFAB> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Hero(
          tag: 'custom_fab',
          child: CustomPaint(
            size: const Size(56, 56),
            painter: FABPainter(
              color: AppColors.primary,
              icon: widget.icon,
            ),
          ),
        ),
      ),
    );
  }
}

class FABPainter extends CustomPainter {
  final Color color;
  final IconData icon;

  FABPainter({required this.color, required this.icon});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw smooth shadow
    final shadowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
      ..isAntiAlias = true;
    canvas.drawCircle(center + const Offset(0, 6), radius - 2, shadowPaint);

    // Draw main circle with subtle premium gradient
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color,
          Color.lerp(color, Colors.black, 0.1)!, // Slightly darker at bottom
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawCircle(center, radius, paint);

    // Draw subtle border for extra sharpness
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = true;
    canvas.drawCircle(center, radius, borderPaint);

    // Draw Icon using TextPainter for perfect vector rendering from font
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: 28,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: Colors.white,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
