import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../core/params/report_params.dart';
import '../../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../../core/utilities/app_validators.dart';
import '../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../../../../../../../services/get_it.dart';
import '../../../../../../../domain/usecase/report_post_usecase.dart';
import '../../../../../enums/report_reason.dart';
import '../../../../../../../../../../core/widgets/step_progress_indicator.dart';

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
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (BuildContext context, int index) {
        final ReportType type = ReportType.values[index];
        return ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          minVerticalPadding: 0,
          title: Text(
            type.code.tr(),
            style: TextTheme.of(context).bodySmall,
          ),
          trailing: Icon(Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface),
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
    super.key,
  });

  final TextEditingController noteController;
  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  State<ReportStep2> createState() => _ReportStep2State();
}

class _ReportStep2State extends State<ReportStep2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // take up all space
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16),
              CustomTextFormField(
                validator: (String? value) => AppValidator.isEmpty(value),
                contentPadding: const EdgeInsets.all(6),
                autoFocus: true, // keyboard opens automatically
                isExpanded: true,
                hint: 'add_reason_for_repot_please'.tr(),
                labelText: 'reason'.tr(),
                controller: widget.noteController,
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onTap: () {
                    // Validate inside widget
                    if (_formKey.currentState?.validate() ?? false) {
                      widget.onSubmit();
                    }
                  },
                  title: 'submit'.tr(),
                  isLoading: widget.isLoading,
                ),
              ),
            ],
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const EmptyPageWidget(icon: Icons.new_releases_rounded),
            const SizedBox(height: 24),

            Text(
              'post_reported_title'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8), // reduced gap
            Text(
              '${'post_reported_message'.tr()} "${selectedType?.title ?? ''}" ${'post_reported_message_extra'.tr()}',
              textAlign: TextAlign.center,
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

/// --- MAIN BOTTOM SHEET WIDGET ---
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: 48,
                    child: state.step == 2
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () =>
                                setState(() => state = state.copyWith(step: 1)),
                          )
                        : null,
                  ),
                  Flexible(
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                        children: <InlineSpan>[
                          TextSpan(text: 'report'.tr()),
                          if (state.step != 1) const TextSpan(text: '('),
                          if (state.step != 1)
                            TextSpan(
                              text: state.selectedType?.code.tr() ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          if (state.step != 1) const TextSpan(text: ')'),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Step indicator
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
                      return ReportStep1(onSelect: (ReportType type) {
                        setState(() => state =
                            state.copyWith(step: 2, selectedType: type));
                      });
                    } else if (state.step == 2) {
                      return ReportStep2(
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
    ReportParams(
      title: type.title,
      reportReason: note,
      postId: postId,
    ),
  );
  if (!context.mounted) return false;
  return result is DataSuccess;
}
