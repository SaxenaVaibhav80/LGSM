import 'package:flutter/material.dart';

class CustomLoader extends StatefulWidget {
  final double size;
  final Color color;

  const CustomLoader({
    super.key,
    this.size = 50.0,
    this.color = Colors.orange,
  });

  @override
  State<CustomLoader> createState() => _CustomSignupLoaderState();
}

class _CustomSignupLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.shopping_basket_outlined,
                    size: widget.size,
                    color: widget.color,
                  ),
                  Transform.translate(
                    offset: Offset(0, -widget.size / 4),
                    child: Icon(
                      Icons.arrow_upward,
                      size: widget.size / 2,
                      color: widget.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
