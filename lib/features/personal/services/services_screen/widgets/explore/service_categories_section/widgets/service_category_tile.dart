import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../domain/entity/service_category_entity.dart';
import '../../../../providers/services_page_provider.dart';
import 'categorized_services_screen.dart';

class SeviceCategoryTile extends StatelessWidget {
  const SeviceCategoryTile({required this.category, super.key});
  final ServiceCategoryEntity category;
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
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: <Widget>[
            Expanded(child: CustomNetworkImage(imageURL: category.imgURL)),
            Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  category.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                )),
          ],
        ),
      ),
    );
  }
}
