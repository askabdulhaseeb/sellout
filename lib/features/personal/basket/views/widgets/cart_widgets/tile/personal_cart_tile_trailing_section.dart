import 'package:flutter/material.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../data/sources/local/local_cart.dart';

class PersonalCartTileTrailingSection extends StatefulWidget {
  const PersonalCartTileTrailingSection({
    required this.item,
    required this.post,
    super.key,
  });
  final CartItemEntity item;
  final PostEntity? post;

  @override
  State<PersonalCartTileTrailingSection> createState() =>
      _PersonalCartTileTrailingSectionState();
}

class _PersonalCartTileTrailingSectionState
    extends State<PersonalCartTileTrailingSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
       
        SizedBox(
            width: 50, child: Switch(value: true, onChanged: (bool value) {}))
      ],
    );
  }
}
