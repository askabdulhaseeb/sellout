import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SlideToTransferSlider extends StatefulWidget {
  const SlideToTransferSlider({
    required this.onTransfer,
    required this.canTransfer,
    required this.isLoading,
    required this.isSuccess,
    this.isError = false,
    super.key,
  });

  final VoidCallback onTransfer;
  final bool canTransfer;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;

  @override
  State<SlideToTransferSlider> createState() => _SlideToTransferSliderState();
}

class _SlideToTransferSliderState extends State<SlideToTransferSlider>
    with SingleTickerProviderStateMixin {
  double _sliderValue = 0.0;
  bool _isDragging = false;
  late double _trackWidth;
  late double _trackPadding;
  late double _thumbSize;
  late double _containerHeight;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SlideToTransferSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading || widget.isSuccess) {
      if (_sliderValue != 1.0) {
        setState(() => _sliderValue = 1.0);
      }
    } else if (widget.isError && !oldWidget.isError) {
      // Error just occurred - shake and show error state briefly
      HapticFeedback.heavyImpact();
      _shakeController.forward().then((_) {
        _shakeController.reset();
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted && !widget.isLoading && !widget.isSuccess) {
            setState(() => _sliderValue = 0.0);
          }
        });
      });
    } else if (oldWidget.isLoading &&
        !widget.isLoading &&
        !widget.isSuccess &&
        !widget.isError) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && !widget.isLoading && !widget.isSuccess) {
          setState(() => _sliderValue = 0.0);
        }
      });
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
    if (widget.isLoading || widget.isSuccess || widget.isError) return;
    double newValue = ((dx - _trackPadding) / _trackWidth).clamp(0.0, 1.0);
    if (_sliderValue == 0.0 && newValue < 0.1) {
      return;
    }
    if (_sliderValue != newValue) {
      setState(() => _sliderValue = newValue);
    }
  }

  void _handleDragEnd() {
    if (!mounted) return;
    if (widget.isLoading || widget.isSuccess || widget.isError) return;
    if (_isDragging) {
      setState(() => _isDragging = false);
    }
    if (_sliderValue >= 0.9) {
      HapticFeedback.mediumImpact();
      setState(() => _sliderValue = 1.0);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onTransfer();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted &&
            _sliderValue != 0.0 &&
            !widget.isLoading &&
            !widget.isSuccess) {
          setState(() => _sliderValue = 0.0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _thumbSize = 48.0;
        _trackPadding = 4.0;
        _containerHeight = 56.0;
        _trackWidth = constraints.maxWidth - 2 * _trackPadding - _thumbSize;

        final double thumbLeft = _trackPadding + (_sliderValue * _trackWidth);

        final Color mainColor;
        final Color backgroundColor;
        final Color progressColor;
        final Color borderColor;

        if (widget.isError) {
          mainColor = colorScheme.error;
          backgroundColor = colorScheme.error.withValues(alpha: 0.08);
          progressColor = colorScheme.error.withValues(alpha: 0.5);
          borderColor = colorScheme.error.withValues(alpha: 0.3);
        } else if (widget.isSuccess) {
          mainColor = Colors.green;
          backgroundColor = Colors.green.withValues(alpha: 0.08);
          progressColor = Colors.green.withValues(alpha: 0.5);
          borderColor = Colors.green.withValues(alpha: 0.3);
        } else if (widget.isLoading || widget.canTransfer) {
          mainColor = colorScheme.primary;
          backgroundColor = colorScheme.primary.withValues(alpha: 0.08);
          progressColor = colorScheme.primary.withValues(alpha: 0.4);
          borderColor = colorScheme.primary.withValues(alpha: 0.2);
        } else {
          mainColor = colorScheme.outline;
          backgroundColor = colorScheme.surfaceContainerHighest;
          progressColor = colorScheme.outline.withValues(alpha: 0.3);
          borderColor = Colors.transparent;
        }

        return AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (BuildContext context, Widget? child) {
            final double shakeOffset =
                _shakeAnimation.value *
                8 *
                ((_shakeController.value * 10).toInt().isEven ? 1 : -1);

            return Transform.translate(
              offset: Offset(shakeOffset, 0),
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _containerHeight,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                // Track background
                Positioned(
                  left: _trackPadding,
                  right: _trackPadding,
                  top: _trackPadding,
                  bottom: _trackPadding,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                // Progress fill
                Positioned(
                  left: _trackPadding,
                  top: _trackPadding,
                  bottom: _trackPadding,
                  child: AnimatedContainer(
                    duration: _isDragging
                        ? Duration.zero
                        : const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    width: (_sliderValue * _trackWidth + _thumbSize / 2).clamp(
                      0.0,
                      _trackWidth + _thumbSize / 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          progressColor,
                          progressColor.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                // Thumb
                AnimatedPositioned(
                  duration: _isDragging
                      ? Duration.zero
                      : const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  left: thumbLeft,
                  top: (_containerHeight - _thumbSize) / 2,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragStart: widget.canTransfer && !widget.isError
                        ? (DragStartDetails details) {
                            if (!mounted) return;
                            HapticFeedback.selectionClick();
                            if (!_isDragging) {
                              setState(() => _isDragging = true);
                            }
                          }
                        : null,
                    onHorizontalDragUpdate:
                        widget.canTransfer && !widget.isError
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
                    onHorizontalDragEnd: widget.canTransfer && !widget.isError
                        ? (DragEndDetails details) {
                            if (!mounted) return;
                            _handleDragEnd();
                          }
                        : null,
                    onHorizontalDragCancel:
                        widget.canTransfer && !widget.isError
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
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: mainColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(child: _buildThumbIcon(colorScheme)),
                    ),
                  ),
                ),
                // Hint text
                if (!_isDragging &&
                    _sliderValue < 0.1 &&
                    widget.canTransfer &&
                    !widget.isError)
                  Positioned(
                    left: _trackPadding + _thumbSize + 12,
                    right: _trackPadding + 12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'slide_to_transfer'.tr(),
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: colorScheme.primary.withValues(alpha: 0.6),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThumbIcon(ColorScheme colorScheme) {
    final Color iconColor = Colors.white;

    if (widget.isError) {
      return Icon(
        Icons.close_rounded,
        color: iconColor,
        size: 26,
        key: const ValueKey<String>('error'),
      );
    }

    if (widget.isSuccess) {
      return Icon(
        Icons.check_rounded,
        color: iconColor,
        size: 26,
        key: const ValueKey<String>('success'),
      );
    }

    if (widget.isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          color: iconColor,
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
              color: iconColor,
              size: 26,
              key: const ValueKey<String>('check'),
            )
          : Icon(
              Icons.double_arrow_rounded,
              color: iconColor,
              size: 24,
              key: const ValueKey<String>('arrow'),
            ),
    );
  }
}
