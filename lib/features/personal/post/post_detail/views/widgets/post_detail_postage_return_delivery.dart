import 'package:flutter/material.dart';
import '../../../domain/entities/post_entity.dart';
import 'post_detail_postage_return_section.dart';
import 'post_detail_return_policy_details.dart';
import 'sellout_bank_guranter_widget.dart';

class ReturnPosrtageAndExtraDetailsSection extends StatelessWidget {
  const ReturnPosrtageAndExtraDetailsSection({
    required this.post,
    super.key,
  });
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          PostDetailPostageReturnSection(post: post),
          const SelloutBankGuranterWidget(),
          const ReturnPolicyDetails(),
        ],
      ),
    );
  }
}
