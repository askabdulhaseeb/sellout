import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/utilities/app_string.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});
  static const String routeName = '/about_us';

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    Widget buildCard(
      String nameKey,
      String roleKey,
      String descriptionKey,
      String imagePath,
    ) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).primaryColor,
            ],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(imagePath),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          nameKey.tr(),
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          roleKey.tr(),
                          style: textTheme.labelMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                textAlign: TextAlign.center,
                descriptionKey.tr(),
                style: textTheme.bodySmall?.copyWith(
                  color:
                      ColorScheme.of(context).onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildWhyCard(String titleKey, String contentKey) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).primaryColor,
            ],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                titleKey.tr(),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                textAlign: TextAlign.center,
                contentKey.tr(),
                style: textTheme.bodySmall?.copyWith(
                    color: ColorScheme.of(context)
                        .onSurface
                        .withValues(alpha: 0.4)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('about_us_title'.tr()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              textAlign: TextAlign.center,
              'about_us_desc'.tr(),
              style: textTheme.bodySmall?.copyWith(
                  color:
                      ColorScheme.of(context).onSurface.withValues(alpha: 0.4)),
            ),
            // const GetInTouchButton(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'meet_sellout_team_title'.tr(),
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'meet_sellout_team_desc'.tr(),
                  style: textTheme.bodySmall?.copyWith(
                      color: ColorScheme.of(context)
                          .onSurface
                          .withValues(alpha: 0.4)),
                ),
                buildCard('zubair_name', 'zubair_role', 'zubair_description',
                    AppStrings.zubair),
                buildCard('abdul_name', 'abdul_role', 'abdul_description',
                    AppStrings.abdul),
                buildCard('ahmed_name', 'ahmed_role', 'ahmed_description',
                    AppStrings.ahmed),
                buildCard('rafah_name', 'rafah_role', 'rafah_description',
                    AppStrings.ayhab),
                buildCard('hammad_name', 'hammad_role', 'hammad_description',
                    AppStrings.hammad),
                buildCard('ahmer_name', 'ahmer_role', 'ahmer_description',
                    AppStrings.ahmer),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: <Widget>[
                Text(
                  'why_choose_title'.tr(),
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  textAlign: TextAlign.center,
                  'why_choose_desc'.tr(),
                  style: textTheme.bodySmall?.copyWith(
                      color: ColorScheme.of(context)
                          .onSurface
                          .withValues(alpha: 0.4)),
                ),
                const SizedBox(height: 12),
                buildWhyCard('global_reach_title', 'global_reach_desc'),
                buildWhyCard('ease_of_use_title', 'ease_of_use_desc'),
                buildWhyCard('security_title', 'security_desc'),
                buildWhyCard('community_title', 'community_desc'),
                buildWhyCard('support', 'support_desc'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GetInTouchButton extends StatelessWidget {
  const GetInTouchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).primaryColor,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'get_in_touch'.tr(),
              style: textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
