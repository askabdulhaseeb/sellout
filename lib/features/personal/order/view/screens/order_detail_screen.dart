import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('order_details'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Product info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://via.placeholder.com/80', // Replace with real image
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Skecher shoes',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$26.00',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${'ordered_on'.tr()}: 13/09/2024',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Order number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${'order_number'.tr()}: 66374-64574-76',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'view_invoice'.tr(),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Dispatched to
            Row(
              children: <Widget>[
                Text(
                  '${'dispatched_to'.tr()}: ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                DropdownButton<String>(
                  value: 'Zubair Hussain',
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      value: 'Zubair Hussain',
                      child: Text('Zubair Hussain'),
                    ),
                  ],
                  onChanged: (String? value) {},
                  underline: const SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Buttons
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              child: Text('post_now'.tr()),
            ),
            const SizedBox(height: 8),
            _buildActionButton(context, 'add_tracking_number'),
            _buildActionButton(context, 'leave_feedback'),
            _buildActionButton(context, 'cancel_order'),
            _buildActionButton(context, 'view_payment_details'),
            _buildActionButton(context, 'contact_buyer'),
            _buildActionButton(context, 'report_buyer'),
            _buildActionButton(context, 'send_refund'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          elevation: 0,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(key.tr()),
        ),
      ),
    );
  }
}
