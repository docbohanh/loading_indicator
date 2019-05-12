import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/src/shape/indicator_painter.dart';

class BallScaleRippleMultiple extends StatefulWidget {
  @override
  _BallScaleRippleMultipleState createState() =>
      _BallScaleRippleMultipleState();
}

class _BallScaleRippleMultipleState extends State<BallScaleRippleMultiple>
    with TickerProviderStateMixin {
  static const _BEGIN_TIMES = [0, 200, 400];

  List<AnimationController> _animationControllers = List(3);
  List<Animation<double>> _opacityAnimations = List(3);
  List<Animation<double>> _scaleAnimations = List(3);
  List<CancelableOperation<int>> _delayFeatures = List(3);

  @override
  void initState() {
    super.initState();
    final cubic = Cubic(0.21, 0.53, 0.56, 0.8);
    for (int i = 0; i < 3; i++) {
      _animationControllers[i] = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1250))
        ..addListener(() => setState(() {}));
      _opacityAnimations[i] = TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.7), weight: 70),
        TweenSequenceItem(tween: Tween(begin: 0.7, end: 0.0), weight: 30),
      ]).animate(
          CurvedAnimation(parent: _animationControllers[i], curve: cubic));
      _scaleAnimations[i] = TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 70),
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 70),
      ]).animate(
          CurvedAnimation(parent: _animationControllers[i], curve: cubic));
      _delayFeatures[i] = CancelableOperation.fromFuture(
          Future.delayed(Duration(milliseconds: _BEGIN_TIMES[i])).then((t) {
        _animationControllers[i].repeat();
      }));
    }
  }

  @override
  void dispose() {
    _delayFeatures.forEach((f) => f.cancel());
    _animationControllers.forEach((f) => f.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List(3);
    for (int i = 0; i < widgets.length; i++) {
      widgets[i] = Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(_scaleAnimations[i].value),
        child: Opacity(
          opacity: _opacityAnimations[i].value,
          child: IndicatorShapeWidget(Shape.ring),
        ),
      );
    }

    return Stack(children: widgets);
  }
}
