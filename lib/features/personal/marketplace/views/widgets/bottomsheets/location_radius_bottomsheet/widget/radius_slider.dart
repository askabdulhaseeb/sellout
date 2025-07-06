import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/theme/app_theme.dart';
import '../../../../providers/marketplace_provider.dart';

class RadiusSlider extends StatelessWidget {
  const RadiusSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider provider, _) {
        return Row(
          children: <Widget>[
            Expanded(
              child: Slider(
                thumbColor: AppTheme.primaryColor,
                activeColor: AppTheme.primaryColor,
                value: provider.selectedRadius.toDouble(),
                min: 1,
                max: 10,
                label: '${provider.selectedRadius.toStringAsFixed(1)} km',
                onChanged: (double value) {
                  provider.setRadius(value);
                },
              ),
            ),
            Text(
              '${provider.selectedRadius.toStringAsFixed(1)} km',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }
}
