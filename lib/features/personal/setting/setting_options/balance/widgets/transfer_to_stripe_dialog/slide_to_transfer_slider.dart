import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
  late double _trackWidth;
  late double _trackPadding;
  late double _thumbSize;
  late double _containerHeight;

  @override
  void didUpdateWidget(covariant SlideToTransferSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.canTransfer && !widget.canTransfer) {
      _resetSlider();
    }
  }

  void _resetSlider() {
    if (!mounted) return;
    if (_sliderValue != 0.0 || _isDragging != false) {
      setState(() {
        _sliderValue = 0.0;
        _isDragging = false;
      });
    }
  }

  void _handleDragUpdate(double dx) {
    if (!mounted) return;
    double newValue = ((dx - _trackPadding) / _trackWidth).clamp(0.0, 1.0);
    // Prevent getting stuck at the beginning by requiring a minimum drag
    if (_sliderValue == 0.0 && newValue < 0.1) {
      return; // Don't update for tiny movements at start
    }
    if (_sliderValue != newValue) {
      setState(() {
        _sliderValue = newValue;
      });
    }
  }

  void _handleDragEnd() {
    if (!mounted) return;
    if (_isDragging) {
      setState(() {
        _isDragging = false;
      });
    }
    // Check if user slid past 90%
    if (_sliderValue >= 0.9) {
      // Call after frame to avoid setState in build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onTransfer();
      });
    }
    // Reset slider after a short delay
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted && _sliderValue != 0.0) {
        setState(() {
          _sliderValue = 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Calculate dimensions once
        _thumbSize = 44.0; // Fixed size for better control
        _trackPadding = 4.0;
        _containerHeight = 52.0;
        _trackWidth = constraints.maxWidth - 2 * _trackPadding - _thumbSize;

        final double thumbLeft = _trackPadding + (_sliderValue * _trackWidth);

        final bool enabled = widget.canTransfer;
        final Color mainColor = enabled
            ? AppColors.primaryColor
            : Colors.grey[400]!;
        final Color backgroundColor = enabled
            ? AppColors.primaryColor.withOpacity(0.08)
            : Colors.grey[200]!;
        final Color progressColor = enabled
            ? AppColors.primaryColor.withOpacity(0.6)
            : Colors.grey[400]!;

        return Container(
          height: _containerHeight,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.0), // Less rounded
            border: enabled
                ? Border.all(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    width: 1.5,
                  )
                : null,
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              // Progress bar background (full width, behind thumb)
              Positioned(
                left: _trackPadding,
                right: _trackPadding + _thumbSize / 2,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),

              // Progress fill
              Positioned(
                left: _trackPadding,
                top: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 50),
                  width: (_sliderValue * _trackWidth).clamp(0.0, _trackWidth),
                  height: _containerHeight,
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(8.0), // Less rounded
                  ),
                ),
              ),

              // Slider thumb
              Positioned(
                left: thumbLeft,
                top: (_containerHeight - _thumbSize) / 2,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragStart: enabled
                      ? (DragStartDetails details) {
                          if (!mounted) return;
                          if (!_isDragging) {
                            setState(() {
                              _isDragging = true;
                            });
                          }
                        }
                      : null,
                  onHorizontalDragUpdate: enabled
                      ? (DragUpdateDetails details) {
                          if (!mounted) return;
                          final RenderBox? box =
                              context.findRenderObject() as RenderBox?;
                          if (box == null) return;
                          final Offset local = box.globalToLocal(
                            details.globalPosition,
                          );
                          _handleDragUpdate(local.dx);
                        }
                      : null,
                  onHorizontalDragEnd: enabled
                      ? (DragEndDetails details) {
                          if (!mounted) return;
                          _handleDragEnd();
                        }
                      : null,
                  onHorizontalDragCancel: enabled
                      ? () {
                          if (!mounted) return;
                          _resetSlider();
                        }
                      : null,
                  child: Container(
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ), // Square with slight rounding
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                          spreadRadius: 0,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.8),
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        child: _sliderValue >= 0.9
                            ? Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 24,
                                key: const ValueKey('check'),
                              )
                            : Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 20,
                                key: const ValueKey('arrow'),
                              ),
                      ),
                    ),
                  ),
                ),
              ),

              // Instruction text
              if (!_isDragging && _sliderValue < 0.1 && enabled)
                Positioned(
                  left: _trackPadding + _thumbSize + 16,
                  right: _trackPadding,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'slide_to_transfer'.tr(),
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
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
