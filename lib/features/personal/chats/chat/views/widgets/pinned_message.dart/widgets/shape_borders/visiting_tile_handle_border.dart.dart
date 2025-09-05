import 'package:flutter/material.dart';

class VisitileTileWithHandleBorder extends ShapeBorder {
  const VisitileTileWithHandleBorder({
    this.handleHeight = 30.0,
    this.handleWidth = 30.0,
    this.handleOffset = 30.0,
    this.bottomCornerRadius = 0,
    this.handleCornerRadius = 8,
  });
  final double handleHeight;
  final double handleWidth;
  final double handleOffset;
  final double bottomCornerRadius;
  final double handleCornerRadius;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: handleHeight);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();

    // Main drawer rectangle with rounded bottom corners
    final RRect mainRect = RRect.fromRectAndCorners(
      Rect.fromLTRB(
          rect.left, rect.top, rect.right, rect.bottom - handleHeight),
      bottomLeft: Radius.circular(bottomCornerRadius),
      bottomRight: Radius.circular(bottomCornerRadius),
    );
    path.addRRect(mainRect);

    // Handle rectangle at bottom-right (fully inside drawer)
    final double handleCenterX = rect.right - handleOffset;
    final Rect handleRect = Rect.fromCenter(
      center: Offset(handleCenterX, rect.bottom - handleHeight / 2),
      width: handleWidth,
      height: handleHeight,
    );
    final RRect handleShape = RRect.fromRectAndCorners(
      handleRect,
      bottomLeft: Radius.circular(handleCornerRadius),
      bottomRight: Radius.circular(handleCornerRadius),
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
