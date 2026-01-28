import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../../../../../visits/view/visit_calender.dart/screens/visit_calender_screen.dart';
import '../../../../domain/entities/post/post_entity.dart';

class PostButtonForUserController {
  void onEditListing(BuildContext context, PostEntity post) {
    Provider.of<AddListingFormProvider>(
      context,
      listen: false,
    ).startediting(post);
  }

  void onOpenCalendar(BuildContext context, PostEntity post) {
    Navigator.pushNamed(
      context,
      VisitCalenderScreen.routeName,
      arguments: <String, String>{'pid': post.postID},
    );
  }

  bool shouldShowCalendar(PostEntity? post) {
    if (post == null) return false;
    return ListingType.viewingList.contains(ListingType.fromJson(post.listID));
  }
}
