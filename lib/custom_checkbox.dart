
import 'package:flutter/material.dart';

class CustomCheckBoxButtonPainter extends CustomPainter {
  final Animation animation;
  final Color color;
  final bool checked;

  CustomCheckBoxButtonPainter({this.animation, this.checked, this.color})
      : super(repaint: animation);
  
  static const double checkerIconSize = 18;

  @override
  void paint(Canvas canvas, Size size) {

    final double tNormalized = 1.0 - animation.value;
    final double t =  1.0 - tNormalized;

    final Offset center = Offset(size.width / 2, size.height / 2);
    
    final Paint borderCirclePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final checkerIconPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0       
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final checkedFilledPaint = Paint()
    ..color = color
    ..strokeWidth = 2.0   
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round;

    // log("----------------${animation.value}");
    canvas.drawCircle(center, size.width / 2, borderCirclePaint);

    canvas.drawCircle(center, size.width / 2 * animation.value, checkedFilledPaint);

    if(t >= 0.5){             
        final double tShrink =  (t - 0.5) * 2.0;       
        _drawCheck(canvas, center - Offset(10, 8), tShrink, checkerIconPaint);           
      }
       
  }

  void _drawCheck(Canvas canvas, Offset origin, double t, Paint paint) {
    if(t >= 0.0 && t <= 1.0){  
    final Path path = Path();
    const Offset start = Offset(checkerIconSize * 0.15, checkerIconSize * 0.45);
    const Offset mid = Offset(checkerIconSize * 0.4, checkerIconSize * 0.7);
    const Offset end = Offset(checkerIconSize * 0.85, checkerIconSize * 0.25);
    if (t < 0.5) {
      final double strokeT = t * 2.0;
      final Offset drawMid = Offset.lerp(start, mid, strokeT);
        path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
        path.lineTo(origin.dx + drawMid.dx, origin.dy + drawMid.dy);
    } else {
      final double strokeT = (t - 0.5) * 2.0;
      final Offset drawEnd = Offset.lerp(mid, end, strokeT);
        path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
        path.lineTo(origin.dx + mid.dx, origin.dy + mid.dy);
        path.lineTo(origin.dx + drawEnd.dx, origin.dy + drawEnd.dy);
    }
    
    canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomCheckBoxButtonPainter oldDelegate) {
    return oldDelegate.checked != checked;
  }
}