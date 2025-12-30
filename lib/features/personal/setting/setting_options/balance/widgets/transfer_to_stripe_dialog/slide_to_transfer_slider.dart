import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/theme/app_colors.dart';

class SlideToTransferSlider extends StatefulWidget {
  const SlideToTransferSlider({
    required this.canTransfer,
    required this.onTransfer,
    super.key,
  });

  final bool canTransfer;
  final VoidCallback onTransfer;

  @override
  State<SlideToTransferSlider> createState() => _SlideToTransferSliderState();
}

class _SlideToTransferSliderState extends State<SlideToTransferSlider> {
  double _sliderValue = 0.0;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double thumbSize = AppSpacing.lg + 8;
        final double trackPadding = 8.0;
        final double trackHeight = 12.0;
        final double containerHeight = 56.0;
        final double trackWidth =
            constraints.maxWidth - 2 * trackPadding - thumbSize;
        final double thumbLeft = trackPadding + (_sliderValue * trackWidth);

        return Container(
          height: containerHeight,
          decoration: BoxDecoration(
            color: widget.canTransfer
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

              // Track progress (only shows while dragging)
              if (_isDragging || _sliderValue > 0)
                Positioned(
                  left: trackPadding,
                  top: (containerHeight - trackHeight) / 2,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: (_sliderValue * trackWidth).clamp(0.0, trackWidth),
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: widget.canTransfer
                          ? AppColors.primaryColor.withOpacity(0.6)
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
                  onHorizontalDragStart: widget.canTransfer
                      ? (DragStartDetails details) {
                          setState(() {
                            _isDragging = true;
                          });
                        }
                      : null,
                  onHorizontalDragUpdate: widget.canTransfer
                      ? (DragUpdateDetails details) {
                          final RenderBox box =
                              context.findRenderObject() as RenderBox;
                          final Offset local = box.globalToLocal(
                            details.globalPosition,
                          );
                          double newValue =
                              ((local.dx - trackPadding) / trackWidth).clamp(
                                0.0,
                                1.0,
                              );
                          setState(() {
                            _sliderValue = newValue;
                          });
                        }
                      : null,
                  onHorizontalDragEnd: widget.canTransfer
                      ? (DragEndDetails details) {
                          setState(() {
                            _isDragging = false;
                          });

                          // Check if user slid past 90%
                          if (_sliderValue >= 0.9) {
                            widget.onTransfer();
                          }

                          // Reset slider
                          setState(() {
                            _sliderValue = 0.0;
                          });
                        }
                      : null,
                  onHorizontalDragCancel: widget.canTransfer
                      ? () {
                          setState(() {
                            _isDragging = false;
                            _sliderValue = 0.0;
                          });
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: widget.canTransfer
                          ? (_sliderValue >= 0.9
                                ? Colors
                                      .green // Turns green when past 90%
                                : AppColors.primaryColor)
                          : Colors.grey[400],
                      borderRadius: BorderRadius.circular(thumbSize / 2),
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
                        _sliderValue >= 0.9 ? Icons.check : Icons.chevron_right,
                        color: Colors.white,
                        size: thumbSize * 0.6,
                      ),
                    ),
                  ),
                ),
              ),

              // Instruction text
              if (!_isDragging && _sliderValue < 0.1 && widget.canTransfer)
                Positioned(
                  left: trackPadding + thumbSize + 12,
                  right: trackPadding,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Slide to transfer',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
