import 'package:flutter/material.dart';

class DrawerHandleBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions =>
      const EdgeInsets.only(bottom: 40); // add 40px space

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    const double handleHeight = 30.0;
    const double handleWidth = 30.0;
    const double handleOffset = 30.0;
    const double bottomCornerRadius = 12.0;

    final Path path = Path();

    // Main drawer rectangle now ends ABOVE the handle
    final Rect mainRect = Rect.fromLTRB(
      rect.left,
      rect.top,
      rect.right,
      rect.bottom - handleHeight, // leave space for handle
    );
    path.addRect(mainRect);

    // Handle rectangle fully inside widget bounds
    final double handleCenterX = rect.right - handleOffset;
    final Rect handleRect = Rect.fromCenter(
      center: Offset(handleCenterX, rect.bottom - handleHeight / 2),
      width: handleWidth,
      height: handleHeight,
    );

    final RRect handleShape = RRect.fromRectAndCorners(
      handleRect,
      bottomLeft: const Radius.circular(bottomCornerRadius),
      bottomRight: const Radius.circular(bottomCornerRadius),
    );

    path.addRRect(handleShape);
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);
}
