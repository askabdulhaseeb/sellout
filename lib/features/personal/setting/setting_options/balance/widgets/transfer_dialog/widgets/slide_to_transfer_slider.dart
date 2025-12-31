import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SlideToTransferSlider extends StatefulWidget {
  const SlideToTransferSlider({
    required this.onTransfer,
    required this.canTransfer,
    required this.isLoading,
    required this.isSuccess,
    super.key,
  });

  final VoidCallback onTransfer;
  final bool canTransfer;
  final bool isLoading;
  final bool isSuccess;

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
  void didUpdateWidget(SlideToTransferSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading || widget.isSuccess) {
      if (_sliderValue != 1.0) {
        setState(() {
          _sliderValue = 1.0;
        });
      }
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
    if (widget.isLoading || widget.isSuccess) return;
    double newValue = ((dx - _trackPadding) / _trackWidth).clamp(0.0, 1.0);
    if (_sliderValue == 0.0 && newValue < 0.1) {
      return;
    }
    if (_sliderValue != newValue) {
      setState(() {
        _sliderValue = newValue;
      });
    }
  }

  void _handleDragEnd() {
    if (!mounted) return;
    if (widget.isLoading || widget.isSuccess) return;
    if (_isDragging) {
      setState(() {
        _isDragging = false;
      });
    }
    if (_sliderValue >= 0.9) {
      setState(() {
        _sliderValue = 1.0;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onTransfer();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted &&
            _sliderValue != 0.0 &&
            !widget.isLoading &&
            !widget.isSuccess) {
          setState(() {
            _sliderValue = 0.0;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _thumbSize = 44.0;
        _trackPadding = 4.0;
        _containerHeight = 52.0;
        _trackWidth = constraints.maxWidth - 2 * _trackPadding - _thumbSize;

        final double thumbLeft = _trackPadding + (_sliderValue * _trackWidth);

        final Color mainColor;
        final Color backgroundColor;
        final Color progressColor;

        if (widget.isSuccess) {
          mainColor = colorScheme.tertiary;
          backgroundColor = colorScheme.tertiary.withOpacity(0.08);
          progressColor = colorScheme.tertiary.withOpacity(0.6);
        } else if (widget.isLoading || widget.canTransfer) {
          mainColor = colorScheme.primary;
          backgroundColor = colorScheme.primary.withOpacity(0.08);
          progressColor = colorScheme.primary.withOpacity(0.6);
        } else {
          mainColor = colorScheme.outline;
          backgroundColor = colorScheme.surfaceContainerHighest;
          progressColor = colorScheme.outline;
        }

        return Container(
          height: _containerHeight,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.0),
            border: widget.canTransfer || widget.isLoading || widget.isSuccess
                ? Border.all(
                    color: widget.isSuccess
                        ? colorScheme.tertiary.withOpacity(0.2)
                        : colorScheme.primary.withOpacity(0.2),
                    width: 1.5,
                  )
                : null,
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Positioned(
                left: _trackPadding,
                right: _trackPadding + _thumbSize / 2,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
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
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Positioned(
                left: thumbLeft,
                top: (_containerHeight - _thumbSize) / 2,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragStart: widget.canTransfer
                      ? (DragStartDetails details) {
                          if (!mounted) return;
                          if (!_isDragging) {
                            setState(() {
                              _isDragging = true;
                            });
                          }
                        }
                      : null,
                  onHorizontalDragUpdate: widget.canTransfer
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
                  onHorizontalDragEnd: widget.canTransfer
                      ? (DragEndDetails details) {
                          if (!mounted) return;
                          _handleDragEnd();
                        }
                      : null,
                  onHorizontalDragCancel: widget.canTransfer
                      ? () {
                          if (!mounted) return;
                          _resetSlider();
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: colorScheme.shadow.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: colorScheme.onPrimary.withOpacity(0.8),
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: _buildThumbIcon(colorScheme),
                    ),
                  ),
                ),
              ),
              if (!_isDragging && _sliderValue < 0.1 && widget.canTransfer)
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
                        color: colorScheme.primary,
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

  Widget _buildThumbIcon(ColorScheme colorScheme) {
    if (widget.isSuccess) {
      return Icon(
        Icons.check_rounded,
        color: colorScheme.onTertiary,
        size: 24,
        key: const ValueKey<String>('success'),
      );
    }

    if (widget.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: colorScheme.onPrimary,
          strokeWidth: 2.5,
          key: const ValueKey<String>('loading'),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: _sliderValue >= 0.9
          ? Icon(
              Icons.check_rounded,
              color: colorScheme.onPrimary,
              size: 24,
              key: const ValueKey<String>('check'),
            )
          : Icon(
              Icons.arrow_forward_ios_rounded,
              color: colorScheme.onPrimary,
              size: 20,
              key: const ValueKey<String>('arrow'),
            ),
    );
  }
}
