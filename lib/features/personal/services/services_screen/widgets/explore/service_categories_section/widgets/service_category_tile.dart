import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/enums/business/services/service_category_type.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../providers/services_page_provider.dart';
import 'categorized_services_screen.dart';

class SeviceCategoryTile extends StatelessWidget {
  const SeviceCategoryTile({required this.category, super.key});
  final ServiceCategoryType category;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ServicesPageProvider pro = context.read<ServicesPageProvider>();
        pro.setSelectedCategory(category);
        await pro.fetchServicesByCategory(category);

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute<CategorizedServicesScreen>(
              builder: (_) => const CategorizedServicesScreen(),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: CustomNetworkImage(
                  imageURL: category.imageURL,
                  placeholder: category.name,
                  fit: BoxFit.cover,
                  size: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                category.code,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ).tr(),
            ),
          ],
        ),
      ),
    );
  }
}
