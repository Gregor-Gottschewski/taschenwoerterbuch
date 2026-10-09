import 'dart:math';

import 'package:flutter/material.dart';

class SketchPainter extends CustomPainter {
  SketchPainter({
    this.seed = 1,
    this.paper,
    this.scribble,
    required this.stroke,
    this.strokeWidth = 2,
    this.roughness = 1.8,
    this.wobbleLength = 60,
    this.scribbleWidth = 6,
    this.overshoot = 5,
    this.shadow = Offset.zero,
    this.outline = true,
  });

  final int seed;
  final Color? paper, scribble;
  final Color stroke;
  final double strokeWidth, roughness, wobbleLength, scribbleWidth, overshoot;
  final Offset shadow;

  final bool outline;

  Path _wobblyRect(Rect r, Random rnd) {
    double j() => (rnd.nextDouble() - .5) * 2 * roughness;
    final pts = [r.topLeft, r.topRight, r.bottomRight, r.bottomLeft];
    final p = Path()..moveTo(pts[0].dx + j(), pts[0].dy + j());
    for (var i = 1; i <= 4; i++) {
      final a = pts[i - 1], b = pts[i % 4];
      // Long edges are split so they wobble as much as short ones.
      final segments = max(1, ((b - a).distance / wobbleLength).round());
      for (var s = 1; s <= segments; s++) {
        final from = Offset.lerp(a, b, (s - .5) / segments)!;
        final to = Offset.lerp(a, b, s / segments)!;
        p.quadraticBezierTo(
          from.dx + j(),
          from.dy + j(),
          to.dx + j(),
          to.dy + j(),
        );
      }
    }
    return p;
  }

  void _scribblePass(
    Canvas canvas,
    Rect r,
    Random rnd,
    Color color, {
    required double slant,
    required double alpha,
    double from = 0,
    double to = 1,
  }) {
    double over() => (rnd.nextDouble() * 1.3 - .3) * overshoot;

    final paint = Paint()
      ..color = color.withAlpha((alpha * 255).round())
      ..style = PaintingStyle.stroke
      ..strokeWidth = scribbleWidth * (.85 + rnd.nextDouble() * .3)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final xStart = r.left + r.width * from - max(slant, 0);
    final xEnd = r.left + r.width * to - min(slant, 0);

    final path = Path();
    var x = xStart;
    var i = 0;
    path.moveTo(x + over(), r.top + over());
    while (x <= xEnd) {
      x += scribbleWidth * (.5 + rnd.nextDouble() * 1.1);
      final isBottom = i.isEven;
      path.lineTo(
        x + (isBottom ? slant : 0) + over(),
        (isBottom ? r.bottom : r.top) + over(),
      );
      i++;
    }
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final inset = roughness + strokeWidth + overshoot + 4;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - 2 * inset - 4,
      size.height - 2 * inset - 4,
    );

    if (shadow != Offset.zero) {
      canvas.drawPath(
        _wobblyRect(rect.shift(shadow), Random(seed)),
        Paint()
          ..color = stroke
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
    }

    if (paper != null) {
      canvas.drawPath(_wobblyRect(rect, Random(seed)), Paint()..color = paper!);
    }

    if (scribble != null) {
      final rnd = Random(seed * 31 + 5);
      _scribblePass(
        canvas,
        rect,
        rnd,
        scribble!,
        slant: rect.height * .35,
        alpha: .55,
      );
      _scribblePass(
        canvas,
        rect,
        rnd,
        scribble!,
        slant: -rect.height * .25,
        alpha: .35,
        from: rnd.nextDouble() * .3,
        to: .55 + rnd.nextDouble() * .45,
      );
    }

    if (!outline) return;

    final line = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(_wobblyRect(rect, Random(seed)), line);
  }

  @override
  bool shouldRepaint(SketchPainter o) =>
      o.seed != seed ||
      o.paper != paper ||
      o.scribble != scribble ||
      o.stroke != stroke ||
      o.strokeWidth != strokeWidth ||
      o.roughness != roughness ||
      o.wobbleLength != wobbleLength ||
      o.scribbleWidth != scribbleWidth ||
      o.overshoot != overshoot ||
      o.shadow != shadow ||
      o.outline != outline;
}
