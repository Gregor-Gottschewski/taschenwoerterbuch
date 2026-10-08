import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';
import 'package:taschenwoerterbuch/l10n/generated/app_localizations.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_painter.dart';

class _ClippedPainter extends CustomPainter {
  _ClippedPainter(this.inner, this.from, this.to);

  final SketchPainter inner;
  final double from, to;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(size.width * from, 0, size.width * to, size.height),
    );
    inner.paint(canvas, size);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ClippedPainter o) =>
      o.from != from || o.to != to || inner.shouldRepaint(o.inner);
}

class SketchProgressBar extends StatefulWidget {
  const SketchProgressBar({super.key, this.value, this.height = 44});

  final double? value;
  final double height;

  @override
  State<SketchProgressBar> createState() => _SketchProgressBarState();
}

class _SketchProgressBarState extends State<SketchProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void initState() {
    super.initState();
    if (widget.value == null) _controller.repeat();
  }

  @override
  void didUpdateWidget(SketchProgressBar old) {
    super.didUpdateWidget(old);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const seed = 7;
    final frame = SketchPainter(
      seed: seed,
      stroke: colors.sketchStroke,
      paper: colors.paper,
    );
    final fillPainter = SketchPainter(
      seed: seed,
      stroke: colors.sketchStroke,
      scribble: colors.scribble,
    );

    return Semantics(
      value: widget.value == null
          ? null
          : AppLocalizations.of(context)
                .percentValue((widget.value! * 100).round()),
      child: SizedBox(
        height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: frame),
            if (widget.value != null)
              CustomPaint(
                painter: _ClippedPainter(
                  fillPainter,
                  0,
                  widget.value!.clamp(0.0, 1.0),
                ),
              )
            else
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = _controller.value * 1.35 - .35;
                  return CustomPaint(
                    painter: _ClippedPainter(
                      fillPainter,
                      t.clamp(0.0, 1.0),
                      (t + .35).clamp(0.0, 1.0),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class SketchSpinner extends StatefulWidget {
  const SketchSpinner({super.key, this.size = 48, this.color});

  final double size;

  final Color? color;

  @override
  State<SketchSpinner> createState() => _SketchSpinnerState();
}

class _SketchSpinnerState extends State<SketchSpinner>
    with SingleTickerProviderStateMixin {
  static const _cycles = 100000;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    upperBound: _cycles.toDouble(),
    duration: const Duration(milliseconds: 1800 * _cycles),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Lädt',
      child: SizedBox.square(
        dimension: widget.size,
        child: CustomPaint(
          painter: _SpinnerPainter(
            _controller,
            widget.color ?? context.colors.sketchStroke,
          ),
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter(this.animation, this.color) : super(repaint: animation);

  final Animation<double> animation;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cycle = animation.value.floor();
    final t = animation.value - cycle;

    final head = Curves.easeInOut.transform((t / .55).clamp(0.0, 1.0));
    final tail = Curves.easeInOut.transform(((t - .72) / .28).clamp(0.0, 1.0));
    if (head <= tail) return;

    final center = size.center(Offset.zero);
    final base = size.shortestSide / 2 - 5;

    for (var pass = 0; pass < 2; pass++) {
      final rnd = Random(cycle * 7 + pass * 101 + 3);
      final startAngle = -pi / 2 + (rnd.nextDouble() - .5) * .8;
      final phase = rnd.nextDouble() * 2 * pi;
      final amp = 1.2 + rnd.nextDouble() * 1.4;
      final wave = 2 + rnd.nextInt(2);
      final drift = 2.5 + rnd.nextDouble() * 2;
      const turns = 1.08;

      Offset at(double u) {
        final a = startAngle + u * turns * 2 * pi;
        final r = base + amp * sin(wave * a + phase) - drift * u + pass * .8;
        return center + Offset(cos(a), sin(a)) * r;
      }

      const steps = 64;
      final path = Path();
      final from = tail, to = head;
      for (var i = 0; i <= steps; i++) {
        final p = at(from + (to - from) * i / steps);
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = pass == 0 ? 2.4 : 1.4,
      );
    }
  }

  @override
  bool shouldRepaint(_SpinnerPainter o) => o.color != color;
}
