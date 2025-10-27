import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../domain/entities/sub_category_entity.dart';
import '../../providers/add_listing_form_provider.dart';

class CategorySelectionBottomSheet extends StatefulWidget {
  const CategorySelectionBottomSheet({required this.subCategories, super.key});
  final List<SubCategoryEntity> subCategories;

  @override
  State<CategorySelectionBottomSheet> createState() =>
      _CategorySelectionBottomSheetState();
}

class _CategorySelectionBottomSheetState
    extends State<CategorySelectionBottomSheet> {
  final List<SubCategoryEntity> _selectedStack = <SubCategoryEntity>[];
  late final TextEditingController _searchController;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()
      ..addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider formProvider =
        Provider.of<AddListingFormProvider>(context, listen: false);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final List<SubCategoryEntity> filteredCategories = _filteredCategories();
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return FractionallySizedBox(
      heightFactor: 1,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Material(
          color: colorScheme.surface,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg + AppSpacing.sm + bottomInset,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          if (_selectedStack.isEmpty) {
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              _selectedStack.removeLast();
                            });
                            _resetSearch();
                          }
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      Expanded(
                        child: Opacity(
                          opacity: 0.85,
                          child: Text(
                            'category'.tr(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: Navigator.of(context).pop,
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  if (_selectedStack.isNotEmpty) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: <Widget>[
                        for (int i = 0; i < _selectedStack.length; i++)
                          _buildBreadcrumbChip(
                            label: _selectedStack[i].title,
                            isActive: i == _selectedStack.length - 1,
                            onTap: i == _selectedStack.length - 1
                                ? null
                                : () {
                                    setState(() {
                                      _selectedStack.removeRange(
                                        i + 1,
                                        _selectedStack.length,
                                      );
                                    });
                                    _resetSearch();
                                  },
                            colorScheme: colorScheme,
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'search'.tr(),
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: _searchController.clear,
                              icon: const Icon(Icons.clear_rounded),
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.4),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.primary),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainer.withValues(
                          alpha:
                              theme.brightness == Brightness.dark ? 0.18 : 0.5),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: filteredCategories.isEmpty
                          ? _buildEmptyState(theme)
                          : ListView.separated(
                              key: ValueKey<String>(
                                '${_selectedStack.length}-${_searchTerm.hashCode}',
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.xs,
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemCount: filteredCategories.length,
                              separatorBuilder: (_, __) => Container(
                                color: colorScheme.outline,
                                height: 1,
                                width: double.infinity,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                final SubCategoryEntity category =
                                    filteredCategories[index];
                                final bool hasNested =
                                    category.subCategory.isNotEmpty &&
                                        formProvider.listingType !=
                                            ListingType.pets;
                                return _CategoryTile(
                                  subCategory: category,
                                  hasNested: hasNested,
                                  onTap: () =>
                                      _onCategoryTap(category, formProvider),
                                  colorScheme: colorScheme,
                                  theme: theme,
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSearchChanged() {
    final String nextTerm = _searchController.text.trim().toLowerCase();
    if (_searchTerm == nextTerm) {
      return;
    }
    setState(() => _searchTerm = nextTerm);
  }

  List<SubCategoryEntity> _currentLevelCategories() {
    if (_selectedStack.isEmpty) {
      return widget.subCategories;
    }
    return _selectedStack.last.subCategory;
  }

  List<SubCategoryEntity> _filteredCategories() {
    final List<SubCategoryEntity> currentOptions = _currentLevelCategories();
    if (_searchTerm.isEmpty) {
      return currentOptions;
    }
    return currentOptions
        .where((SubCategoryEntity category) =>
            category.title.toLowerCase().contains(_searchTerm))
        .toList(growable: false);
  }

  void _onCategoryTap(
    SubCategoryEntity category,
    AddListingFormProvider formProvider,
  ) {
    final bool isLeaf = category.subCategory.isEmpty;
    final bool isFoodDrink =
        formProvider.listingType == ListingType.foodAndDrink;
    // For food/drink, only allow selection of leaf nodes
    if (isFoodDrink) {
      if (isLeaf) {
        debugPrint('🟢 Returning address: ${category.address}');
        Navigator.pop(context, category);
      } else {
        setState(() => _selectedStack.add(category));
        _resetSearch();
      }
      return;
    }
    // For pets, allow selection of any node
    if (formProvider.listingType == ListingType.pets) {
      debugPrint('🟢 Returning address: ${category.address}');
      Navigator.pop(context, category);
      return;
    }
    // For other types, allow selection of leaf or parent
    if (isLeaf) {
      debugPrint('🟢 Returning address: ${category.address}');
      Navigator.pop(context, category);
    } else {
      setState(() => _selectedStack.add(category));
      _resetSearch();
    }
  }

  void _resetSearch() {
    if (_searchController.text.isEmpty) {
      return;
    }
    _searchController.clear();
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.search_off_rounded,
            size: 42,
            color: theme.colorScheme.outline.withValues(alpha: 0.8),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'no_categories_found'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbChip({
    required String label,
    required bool isActive,
    required ColorScheme colorScheme,
    VoidCallback? onTap,
  }) {
    final Color background = isActive
        ? colorScheme.primary.withValues(alpha: 0.14)
        : colorScheme.surfaceContainer.withValues(alpha: 0.45);
    final Color foreground = isActive
        ? colorScheme.primary
        : colorScheme.onSurface.withValues(alpha: 0.75);

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.subCategory,
    required this.hasNested,
    required this.onTap,
    required this.colorScheme,
    required this.theme,
  });

  final SubCategoryEntity subCategory;
  final bool hasNested;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final Color tileColor = colorScheme.surfaceContainer.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.22 : 0.5,
    );

    return ListTile(
      minVerticalPadding: 2,
      dense: true,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: tileColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      title: Text(
        subCategory.title,
        style: theme.textTheme.bodyLarge,
      ),
      trailing: hasNested
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '${subCategory.subCategory.length}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
