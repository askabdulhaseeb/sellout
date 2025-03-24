import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../post/domain/entities/post_entity.dart';
import '../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
import '../providers/explore_provider.dart';

class ExploreProductsGridview extends StatefulWidget {
  const ExploreProductsGridview({required this.showPersonal, super.key});
  final bool showPersonal;

  @override
  ExploreProductsGridviewState createState() => ExploreProductsGridviewState();
}

class ExploreProductsGridviewState extends State<ExploreProductsGridview> {
  @override
  void initState() {
    super.initState();
    final ExploreProvider exploreProvider =
        Provider.of<ExploreProvider>(context, listen: false);
    if (exploreProvider.posts.isEmpty) {
      exploreProvider.getFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreProvider>(
      builder: (BuildContext context, ExploreProvider controller, _) {
        final List<String> categories = widget.showPersonal
            ? controller.getPersonalCategories()
            : controller.getBusinessCategories();

        // Fetch filtered posts directly from the provider
        final List<PostEntity> filteredFeed = widget.showPersonal
            ? controller.getPersonalPosts().toSet().toList()
            : controller.getBusinessPosts().toSet().toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.showPersonal ? 'personal'.tr() : 'business'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (filteredFeed.length > 4)
                  TextButton(
                    onPressed: controller.toggleShowAll,
                    child: Text(
                      controller.showAll ? 'See Less'.tr() : 'See All'.tr(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  final String category = categories[index];
                  final String selectedCategory = widget.showPersonal
                      ? controller.selectedPersonalCategory
                      : controller.selectedBusinessCategory;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      showCheckmark: false,
                      label: Text(
                        category.tr(),
                        style: TextStyle(
                          color: selectedCategory == category
                              ? Theme.of(context).colorScheme.onPrimary
                              : Colors.grey,
                        ),
                      ),
                      selected: selectedCategory == category,
                      onSelected: (bool selected) {
                        widget.showPersonal
                            ? controller
                                .updateSelectedPersonalCategory(category)
                            : controller
                                .updateSelectedBusinessCategory(category);
                      },
                      selectedColor: Colors.black,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            if (filteredFeed.isEmpty)
              const Center(
                child: Text(
                  'No items available',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: filteredFeed.length,
                itemBuilder: (BuildContext context, int index) {
                  return PostGridViewTile(post: filteredFeed[index]);
                },
              ),
          ],
        );
      },
    );
  }
}
