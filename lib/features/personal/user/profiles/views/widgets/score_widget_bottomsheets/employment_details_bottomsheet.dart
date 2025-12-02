import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/coming_soon_overlay.dart';

class EmploymentDetailsBottomSheet extends StatelessWidget {
  const EmploymentDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'employment_details'.tr(),
                style: TextTheme.of(context).titleMedium,
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Stack(children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    Center(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 8),
                          Container(
                            height: 20,
                            width: 100,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 40,
                            width: 250,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(Icons.location_on, size: 16),
                              const SizedBox(width: 4),
                              Container(
                                height: 16,
                                width: 120,
                                color: Colors.grey.shade300,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'experience'.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: List.generate(3, (int index) {
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  title: Container(
                                    height: 16,
                                    width: 120,
                                    color: Colors.grey.shade300,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(height: 4),
                                      Container(
                                        height: 12,
                                        width: 180,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        height: 12,
                                        width: 150,
                                        color: Colors.grey.shade300,
                                      ),
                                    ],
                                  ),
                                ),
                                if (index != 2)
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Divider(
                                      color: Colors.grey.shade300,
                                      thickness: 1,
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ComingSoonOverlay(
                  title: 'coming_soon'.tr(),
                  subtitle: 'business_employment_coming_soon'.tr(),
                  icon: CupertinoIcons.hourglass),
            ])));
  }
}
