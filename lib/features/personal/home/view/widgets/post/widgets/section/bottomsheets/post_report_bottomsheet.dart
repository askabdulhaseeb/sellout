import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../core/params/report_params.dart';
import '../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../../../../core/widgets/indicators/step_progress_indicator.dart';
import '../../../../../../../../../core/widgets/inputs/custom_textformfield.dart';
import '../../../../../../../../../core/widgets/text_display/empty_page_widget.dart';
import '../../../../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../../../../core/widgets/utils/app_snackbar.dart';
import '../../../../../../../../../services/get_it.dart';
import '../../../../../../../post/domain/usecase/report_post_usecase.dart';
import '../../../../../enums/report_reason.dart';

/// --- STATE CLASS ---
class PostReportState {
  const PostReportState({
    this.step = 1,
    this.isLoading = false,
    this.selectedType,
  });
  final int step;
  final bool isLoading;
  final ReportType? selectedType;

  PostReportState copyWith({
    int? step,
    bool? isLoading,
    ReportType? selectedType,
  }) {
    return PostReportState(
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

/// --- STEP 1 ---
class ReportStep1 extends StatelessWidget {
  const ReportStep1({required this.onSelect, super.key});
  final Function(ReportType) onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: ReportType.values.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (BuildContext context, int index) {
        final ReportType type = ReportType.values[index];
        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ),
          minVerticalPadding: 0,
          title: Text(type.code.tr(), style: TextTheme.of(context).bodySmall),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onTap: () => onSelect(type),
        );
      },
    );
  }
}

/// --- STEP 2 ---
class ReportStep2 extends StatefulWidget {
  const ReportStep2({
    required this.noteController,
    required this.isLoading,
    required this.onSubmit,
    required this.selectedType,
    super.key,
  });

  final TextEditingController noteController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final ReportType selectedType;

  @override
  State<ReportStep2> createState() => _ReportStep2State();
}

class _ReportStep2State extends State<ReportStep2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        // keyboard pushes content up
        resizeToAvoidBottomInset: true,

        // === Main content ===
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 0,
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.primaryColor,
                        child: const Icon(Icons.report, color: Colors.white),
                      ),
                      title: Text(
                        widget.selectedType.title.tr(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  CustomTextFormField(
                    validator: (String? value) => AppValidator.isEmpty(value),
                    contentPadding: const EdgeInsets.all(10),
                    autoFocus: true,
                    isExpanded: true,
                    labelText: 'reason'.tr(),
                    hint: 'add_reason_for_repot_please'.tr(),
                    controller: widget.noteController,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 80), // leave space for button
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onSubmit();
                  }
                },
                title: 'submit'.tr(),
                isLoading: widget.isLoading,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// --- STEP 3 ---
class ReportStep3 extends StatelessWidget {
  const ReportStep3({
    required this.selectedType,
    required this.onDone,
    super.key,
  });
  final ReportType? selectedType;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Center(
      // centers everything vertically and horizontally
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          spacing: 6,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const EmptyPageWidget(icon: Icons.new_releases_rounded),
            Flexible(
              child: Text(
                'post_reported_title'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Flexible(
              child: Text(
                '${'post_reported_message'.tr()} "${selectedType?.title ?? ''}" ${'post_reported_message_extra'.tr()}',
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),

            CustomElevatedButton(
              onTap: onDone,
              title: 'done'.tr(),
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }
}

class PostReportBottomSheet extends StatefulWidget {
  const PostReportBottomSheet({required this.postId, super.key});
  final String postId;

  @override
  State<PostReportBottomSheet> createState() => _PostReportBottomSheetState();
}

class _PostReportBottomSheetState extends State<PostReportBottomSheet> {
  PostReportState state = const PostReportState();
  final TextEditingController noteController = TextEditingController();

  Future<void> submit() async {
    if (state.isLoading || state.selectedType == null) return;

    setState(() => state = state.copyWith(isLoading: true));
    final bool ok = await _submitReport(
      context,
      state.selectedType!,
      widget.postId,
      noteController.text.trim(),
    );

    if (!mounted) return;

    ok ? null : AppSnackBar.showSnackBar(context, 'report_failed'.tr());

    setState(() => state = state.copyWith(isLoading: false, step: ok ? 3 : 2));
  }

  @override
  Widget build(BuildContext context) {
    final List<int> steps = <int>[1, 2, 3];
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (state.step == 1) {
              Navigator.pop(context);
            } else {
              setState(() => state = state.copyWith(step: state.step - 1));
            }
          },
        ),
        title: const AppBarTitle(titleKey: 'report'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              StepProgressIndicator<int>(
                currentStep: state.step,
                steps: steps,
                stepsStrs: const <String>[],
                onChanged: (int s) =>
                    setState(() => state = state.copyWith(step: s)),
              ),
              const SizedBox(height: 16),
              // Steps body
              Expanded(
                child: Builder(
                  builder: (_) {
                    if (state.step == 1) {
                      return ReportStep1(
                        onSelect: (ReportType type) {
                          setState(
                            () => state = state.copyWith(
                              step: 2,
                              selectedType: type,
                            ),
                          );
                        },
                      );
                    } else if (state.step == 2) {
                      if (state.selectedType == null) {
                        return const Center(
                          child: Text('Please select a report type.'),
                        );
                      }
                      return ReportStep2(
                        selectedType: state.selectedType!,
                        noteController: noteController,
                        isLoading: state.isLoading,
                        onSubmit: submit,
                      );
                    } else {
                      return ReportStep3(
                        selectedType: state.selectedType,
                        onDone: () => Navigator.pop(context),
                      );
                    }
                  },
                ),
              ),
              // Loader overlay at the bottom of the stack
              if (state.isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.1),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// --- CALL THIS FUNCTION TO SHOW BOTTOM SHEET ---
void showPostReportBottomSheet(BuildContext context, String postId) {
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return PostReportBottomSheet(postId: postId);
    },
  );
}

/// --- SUBMIT FUNCTION ---
Future<bool> _submitReport(
  BuildContext context,
  ReportType type,
  String postId,
  String note,
) async {
  final ReportUsecase reportUsecase = ReportUsecase(locator());
  final DataState<bool> result = await reportUsecase.call(
    ReportParams(title: type.title, reportReason: note, postId: postId),
  );
  if (!context.mounted) return false;
  return result is DataSuccess;
}
