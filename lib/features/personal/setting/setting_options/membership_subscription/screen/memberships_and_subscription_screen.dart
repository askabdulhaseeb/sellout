import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/widgets/text_display/coming_soon_overlay.dart';

class MembershipsAndSubscriptionScreen extends StatelessWidget {
  const MembershipsAndSubscriptionScreen({super.key});
  static String routeName = '/membership';
  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> plans = <Map<String, Object>>[
      <String, Object>{
        'title': 'Basic Membership',
        'price': 'Free',
        'features': <String>['Access to basic features', 'Community support'],
      },
      <String, Object>{
        'title': 'Pro Membership',
        'price': '249/month',
        'features': <String>[
          'All Basic features',
          'Priority support',
          'Early access to new features',
        ],
      },
      <String, Object>{
        'title': 'Enterprise',
        'price': 'Contact us',
        'features': <String>[
          'All Pro features',
          'Dedicated account manager',
          'Custom integrations',
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memberships & Subscriptions'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: plans.length,
              itemBuilder: (BuildContext context, int index) {
                final Map<String, Object> plan = plans[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          plan['title'] as String,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          plan['price'] as String,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(color: Colors.blue),
                        ),
                        const SizedBox(height: 12),
                        ...List<Widget>.from(
                          (plan['features'] as List<String>).map(
                            (String f) => Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.check,
                                  size: 18,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(f)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Subscribed to ${plan['title']}!',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Subscribe'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ComingSoonOverlay(
            title: 'coming_soon'.tr(),
            subtitle: 'membership_coming_soon'.tr(),
            icon: CupertinoIcons.hourglass,
          ),
        ],
      ),
    );
  }
}
