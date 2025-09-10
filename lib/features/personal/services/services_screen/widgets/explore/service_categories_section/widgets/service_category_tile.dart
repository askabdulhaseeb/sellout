import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../domain/entity/service_category_entity.dart';
import '../../../../providers/services_page_provider.dart';
import 'categorized_services_screen.dart';

class SeviceCategoryTile extends StatelessWidget {
  const SeviceCategoryTile({required this.category, super.key});
  final ServiceCategoryENtity category;
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
                  child: Container(
                    color: Colors.green,
                    height: 90,
                    width: 100,
                  )),
            ),
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
