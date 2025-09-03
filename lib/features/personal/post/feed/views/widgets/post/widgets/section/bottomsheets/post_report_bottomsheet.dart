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
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (BuildContext context) {
      return SafeArea(
        child: ListView(
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
            ...ReportType.values.map(
              (ReportType type) => _buildReportItem(context, type, postId),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildReportItem(BuildContext context, ReportType type, String postId) {
  return ListTile(
    title: Text(
      type.code.tr(),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
    ),
    trailing: Icon(
      Icons.chevron_right,
      color: Theme.of(context).colorScheme.onSurface,
    ),
    onTap: () => _handleReportTap(context, type, postId),
  );
}

Future<void> _handleReportTap(
    BuildContext context, ReportType type, String postId) async {
  final ReportUsecase reportUsecase = ReportUsecase(locator());
  final DataState<bool> result = await reportUsecase.call(
    ReportParams(
      title: type.title,
      reportReason: type.reason,
      postId: postId,
    ),
  );

  if (!context.mounted) return; // Prevent context issues

  if (result is DataSuccess) {
    Navigator.pop(context);
    if (!context.mounted) return;
    showReportSuccessBottomSheet(context, type.title);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('report_failed'.tr())),
    );
  }
}
