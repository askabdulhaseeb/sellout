import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../balance_provider.dart';

class SlideToTransferSlider extends StatefulWidget {
  const SlideToTransferSlider({
    required this.onTransfer,
    super.key,
  });

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BalanceProvider provider = context.watch<BalanceProvider>();
    if (provider.isProcessing || provider.isSuccess) {
      if (_sliderValue != 1.0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _sliderValue = 1.0;
            });
          }
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

  void _handleDragUpdate(double dx, BalanceProvider provider) {
    if (!mounted) return;
    if (provider.isProcessing || provider.isSuccess) return;
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

  void _handleDragEnd(BalanceProvider provider) {
    if (!mounted) return;
    if (provider.isProcessing || provider.isSuccess) return;
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
            !provider.isProcessing &&
            !provider.isSuccess) {
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

    return Consumer<BalanceProvider>(
      builder: (BuildContext context, BalanceProvider provider, Widget? child) {
        final bool canTransfer = provider.transferAmount > 0 &&
            provider.transferAmount <= provider.currentBalance &&
            !provider.isProcessing &&
            !provider.isSuccess;

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            _thumbSize = 44.0;
            _trackPadding = 4.0;
            _containerHeight = 52.0;
            _trackWidth =
                constraints.maxWidth - 2 * _trackPadding - _thumbSize;

            final double thumbLeft =
                _trackPadding + (_sliderValue * _trackWidth);

            final Color mainColor;
            final Color backgroundColor;
            final Color progressColor;

            if (provider.isSuccess) {
              mainColor = colorScheme.tertiary;
              backgroundColor = colorScheme.tertiary.withOpacity(0.08);
              progressColor = colorScheme.tertiary.withOpacity(0.6);
            } else if (provider.isProcessing || canTransfer) {
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
                border: canTransfer || provider.isProcessing || provider.isSuccess
                    ? Border.all(
                        color: provider.isSuccess
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
                      width:
                          (_sliderValue * _trackWidth).clamp(0.0, _trackWidth),
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
                      onHorizontalDragStart: canTransfer
                          ? (DragStartDetails details) {
                              if (!mounted) return;
                              if (!_isDragging) {
                                setState(() {
                                  _isDragging = true;
                                });
                              }
                            }
                          : null,
                      onHorizontalDragUpdate: canTransfer
                          ? (DragUpdateDetails details) {
                              if (!mounted) return;
                              final RenderBox? box =
                                  context.findRenderObject() as RenderBox?;
                              if (box == null) return;
                              final Offset local = box.globalToLocal(
                                details.globalPosition,
                              );
                              _handleDragUpdate(local.dx, provider);
                            }
                          : null,
                      onHorizontalDragEnd: canTransfer
                          ? (DragEndDetails details) {
                              if (!mounted) return;
                              _handleDragEnd(provider);
                            }
                          : null,
                      onHorizontalDragCancel: canTransfer
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
                          child: _buildThumbIcon(colorScheme, provider),
                        ),
                      ),
                    ),
                  ),
                  if (!_isDragging && _sliderValue < 0.1 && canTransfer)
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
      },
    );
  }

  Widget _buildThumbIcon(ColorScheme colorScheme, BalanceProvider provider) {
    if (provider.isSuccess) {
      return Icon(
        Icons.check_rounded,
        color: colorScheme.onTertiary,
        size: 24,
        key: const ValueKey<String>('success'),
      );
    }

    if (provider.isProcessing) {
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
