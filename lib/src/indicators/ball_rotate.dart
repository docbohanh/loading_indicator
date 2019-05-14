import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/src/shape/indicator_painter.dart';

class BallRotate extends StatefulWidget {
  @override
  _BallRotateState createState() => _BallRotateState();
}

class _BallRotateState extends State<BallRotate>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _scaleAnimation;
  Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    /// If set b to -0.13, value is negative, [TweenSequence]'s transform will throw error.
    final cubic = Cubic(0.7, 0.87, 0.22, 0.86);
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.6), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _animationController, curve: cubic));
    _rotateAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: cubic));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotateAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: _buildSingleCircle(opacity: 0.8)),
            Expanded(child: SizedBox()),
            Expanded(child: _buildSingleCircle(opacity: 1.0)),
            Expanded(child: SizedBox()),
            Expanded(child: _buildSingleCircle(opacity: 0.8)),
          ],
        ),
      ),
    );
  }

  _buildSingleCircle({double opacity: 1.0}) {
    return Opacity(
      opacity: opacity,
      child: IndicatorShapeWidget(shape: Shape.circle),
    );
  }
}
