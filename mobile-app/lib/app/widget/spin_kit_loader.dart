// ignore_for_file: library_private_types_in_public_api

import 'dart:math' as math show sin, pi;
import 'dart:math';

import 'package:flutter/widgets.dart';

class DelayTween extends Tween<double> {
  DelayTween({super.begin, super.end, required this.delay});

  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

class SpinKitRing extends StatefulWidget {
  const SpinKitRing({
    super.key,
    required this.color,
    this.lineWidth = 3.0,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  });

  final Color color;
  final double size;
  final double lineWidth;
  final Duration duration;
  final AnimationController? controller;

  @override
  _SpinKitRingState createState() => _SpinKitRingState();
}

class _SpinKitRingState extends State<SpinKitRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    _controller =
        (widget.controller ??
              AnimationController(vsync: this, duration: widget.duration))
          ..addListener(() => setState(() {}))
          ..repeat();
    _animation1 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );
    _animation2 = Tween(begin: -2 / 3, end: 1 / 2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.linear),
      ),
    );
    _animation3 = Tween(begin: 0.25, end: 5 / 6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: SpinKitRingCurve()),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        transform: Matrix4.identity()
          ..rotateZ((_animation1.value) * 5 * pi / 6),
        alignment: FractionalOffset.center,
        child: SizedBox.fromSize(
          size: Size.square(widget.size),
          child: CustomPaint(
            foregroundPainter: RingPainter(
              paintWidth: widget.lineWidth,
              trackColor: widget.color,
              progressPercent: _animation3.value,
              startAngle: pi * _animation2.value,
            ),
          ),
        ),
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  RingPainter({
    required this.paintWidth,
    this.progressPercent,
    this.startAngle,
    required this.trackColor,
  }) : trackPaint = Paint()
         ..color = trackColor
         ..style = PaintingStyle.stroke
         ..strokeWidth = paintWidth
         ..strokeCap = StrokeCap.square;

  final double paintWidth;
  final Paint trackPaint;
  final Color trackColor;
  final double? progressPercent;
  final double? startAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - paintWidth) / 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle!,
      2 * pi * progressPercent!,
      false,
      trackPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class SpinKitRingCurve extends Curve {
  const SpinKitRingCurve();

  @override
  double transform(double t) => (t <= 0.5) ? 2 * t : 2 * (1 - t);
}

class SpinKitCircle extends StatefulWidget {
  const SpinKitCircle({
    super.key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  }) : assert(
         !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
             !(itemBuilder == null && color == null),
         'You should specify either a itemBuilder or a color',
       );

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  _SpinKitCircleState createState() => _SpinKitCircleState();
}

class _SpinKitCircleState extends State<SpinKitCircle>
    with SingleTickerProviderStateMixin {
  final List<double> delays = [
    .0,
    -1.1,
    -1.0,
    -0.9,
    -0.8,
    -0.7,
    -0.6,
    -0.5,
    -0.4,
    -0.3,
    -0.2,
    -0.1,
  ];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        (widget.controller ??
              AnimationController(vsync: this, duration: widget.duration))
          ..repeat();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Stack(
          children: List.generate(delays.length, (index) {
            final position = widget.size * .5;
            return Positioned.fill(
              left: position,
              top: position,
              child: Transform(
                transform: Matrix4.rotationZ(30.0 * index * 0.0174533),
                child: Align(
                  alignment: Alignment.center,
                  child: ScaleTransition(
                    scale: DelayTween(
                      begin: 0.0,
                      end: 1.0,
                      delay: delays[index],
                    ).animate(_controller),
                    child: SizedBox.fromSize(
                      size: Size.square(widget.size * 0.15),
                      child: _itemBuilder(index),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        );
}
