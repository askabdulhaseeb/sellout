import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../enums/sort_enums.dart';

class SortBottomSheet extends StatefulWidget {
  const SortBottomSheet({required this.onSortSelected, super.key});
  final Function(SortOption) onSortSelected;

  @override
  SortBottomSheetState createState() => SortBottomSheetState();
}

class SortBottomSheetState extends State<SortBottomSheet> {
  SortOption? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Text(
            'sort'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Divider(),
          SizedBox(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: _buildLeadingIcon(SortOption.dateAscending),
                  title: Text(SortOption.dateAscending.displayName.tr()),
                  onTap: () {
                    setState(() {
                      selectedOption = SortOption.dateAscending;
                    });
                    widget.onSortSelected(SortOption.dateAscending);
                  },
                ),
                ListTile(
                  leading: _buildLeadingIcon(SortOption.dateDescending),
                  title: Text(SortOption.dateDescending.displayName.tr()),
                  onTap: () {
                    setState(() {
                      selectedOption = SortOption.dateDescending;
                    });
                    widget.onSortSelected(SortOption.dateDescending);
                  },
                ),
                ListTile(
                  leading: _buildLeadingIcon(SortOption.priceAscending),
                  title: Text(SortOption.priceAscending.displayName.tr()),
                  onTap: () {
                    setState(() {
                      selectedOption = SortOption.priceAscending;
                    });
                    widget.onSortSelected(SortOption.priceAscending);
                  },
                ),
                ListTile(
                  leading: _buildLeadingIcon(SortOption.priceDescending),
                  title: Text(SortOption.priceDescending.displayName.tr()),
                  onTap: () {
                    setState(() {
                      selectedOption = SortOption.priceDescending;
                    });
                    widget.onSortSelected(SortOption.priceDescending);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build the leading icon with a checkmark
  Widget _buildLeadingIcon(SortOption option) {
    bool isSelected = selectedOption == option;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.red : Colors.grey,
          width: 2,
        ),
        color: isSelected ? Colors.white : Colors.transparent,
      ),
      child: isSelected
          ? const Icon(Icons.check, color: Colors.red, size: 18)
          : null,
    );
  }
}
