import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/theme/app_colors.dart';

class SlideToTransferSlider extends StatelessWidget {
  const SlideToTransferSlider({
    required this.sliderValue,
    required this.canTransfer,
    required this.onTransfer,
    required this.onChanged,
    super.key,
  });

  final double sliderValue;
  final bool canTransfer;
  final ValueChanged<double> onChanged;
  final VoidCallback onTransfer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double thumbSize = AppSpacing.lg + 8; // Make thumb more visible
        final double trackPadding = 8.0;
        final double trackHeight = 12.0;
        final double containerHeight = 56.0;
        final double trackWidth =
            constraints.maxWidth - 2 * trackPadding - thumbSize;
        final double thumbLeft = trackPadding + (sliderValue * trackWidth);

        return Container(
          height: containerHeight,
          decoration: BoxDecoration(
            color: canTransfer
                ? AppColors.primaryColor.withOpacity(0.08)
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(28),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              // Track background
              Positioned(
                left: trackPadding,
                right: trackPadding,
                top: (containerHeight - trackHeight) / 2,
                child: Container(
                  height: trackHeight,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
              ),

              // Track progress
              Positioned(
                left: trackPadding,
                top: (containerHeight - trackHeight) / 2,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: (sliderValue * trackWidth).clamp(0.0, trackWidth),
                  height: trackHeight,
                  decoration: BoxDecoration(
                    color: canTransfer
                        ? AppColors.primaryColor.withOpacity(0.18)
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
              ),

              // Slider thumb
              Positioned(
                left: thumbLeft,
                top: (containerHeight - thumbSize) / 2,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragUpdate: canTransfer
                      ? (DragUpdateDetails details) {
                          final RenderBox box = context.findRenderObject() as RenderBox;
                          final Offset local = box.globalToLocal(
                            details.globalPosition,
                          );
                          double newValue =
                              ((local.dx - trackPadding) / trackWidth).clamp(
                                0.0,
                                1.0,
                              );
                          onChanged(newValue);
                        }
                      : null,
                  onHorizontalDragEnd: canTransfer
                      ? (DragEndDetails details) {
                          if (sliderValue >= 0.9) {
                            onTransfer();
                          } else {
                            onChanged(0.0);
                          }
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: canTransfer
                          ? AppColors.primaryColor
                          : Colors.grey[400],
                      borderRadius: BorderRadius.circular(
                        thumbSize / 2,
                      ), // Circular thumb
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: thumbSize * 0.6,
                      ),
                    ),
                  ),
                ),
              ),

              // Optional: Add text labels
              if (sliderValue < 0.5)
                Positioned(
                  left: thumbLeft + thumbSize + 8,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Slide to transfer',
                      style: TextStyle(
                        color: canTransfer
                            ? AppColors.primaryColor
                            : Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
