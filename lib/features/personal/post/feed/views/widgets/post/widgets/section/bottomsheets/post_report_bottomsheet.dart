import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../core/params/report_params.dart';
import '../../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../../services/get_it.dart';
import '../../../../../../../domain/usecase/report_post_usecase.dart';
import '../../../../../enums/report_reason.dart';
import 'post_report_success_bottomsheet.dart';

void showPostReportBottomSheet(BuildContext context, String postId) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (BuildContext context) {
      return ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: <Widget>[
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'report'.tr(),
              style: TextTheme.of(context).titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ColorScheme.of(context).onSurface,
                  ),
            ),
          ),
          ...ReportType.values.map(
            (ReportType type) => _buildReportItem(context, type, postId),
          ),
        ],
      );
    },
  );
}

Widget _buildReportItem(BuildContext context, ReportType type, String postId) {
  return ListTile(
    title: Text(
      type.code.tr(), // show localized name
      style: TextTheme.of(context).bodyMedium?.copyWith(
            fontSize: 14,
            color: ColorScheme.of(context).onSurface,
          ),
    ),
    trailing: Icon(
      Icons.chevron_right,
      color: ColorScheme.of(context).onSurface,
    ),
    onTap: () => _handleReportTap(context, type, postId),
  );
}

void _handleReportTap(
    BuildContext context, ReportType type, String postId) async {
  final ReportUsecase reportUsecase = ReportUsecase(locator());
  final DataState<bool> result = await reportUsecase.call(
    ReportParams(
      title: type.title,
      reportReason: type.reason,
      postId: postId,
    ),
  );

  if (result is DataSuccess) {
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    showReportSuccessBottomSHeet(context, type.title);
  } else {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('report_failed'.tr())),
    );
  }
}
