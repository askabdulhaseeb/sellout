import '../../../../../core/widgets/inputs/custom_textformfield.dart';
import 'pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utilities/app_string.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';

class LegalDocumentsScreen extends StatefulWidget {
  const LegalDocumentsScreen({super.key});
  static String routeName = '/legal-documents';

  @override
  State<LegalDocumentsScreen> createState() => _LegalDocumentsScreenState();
}

class _LegalDocumentsScreenState extends State<LegalDocumentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  late List<_DocItem> _allDocuments;
  late List<_DocItem> _filteredDocuments;

  @override
  void initState() {
    super.initState();

    _allDocuments = <_DocItem>[
      _DocItem(
        section: 'legal_documents.privacy_security',
        title: 'legal_documents.privacy_policy',
        path: AppStrings.privacyPolicy,
      ),
      _DocItem(
        section: 'legal_documents.privacy_security',
        title: 'legal_documents.facial_scan',
        path: AppStrings.facialScanPrivacyNotice,
      ),
      _DocItem(
        section: 'legal_documents.privacy_security',
        title: 'legal_documents.cookies_policy',
        path: AppStrings.termsAndConditionsDocument,
      ),
      _DocItem(
        section: 'legal_documents.user_agreements',
        title: 'legal_documents.terms_conditions',
        path: AppStrings.termsAndConditionsUserAgreement,
      ),
      _DocItem(
        section: 'legal_documents.user_agreements',
        title: 'legal_documents.community_standards',
        path: AppStrings.communityStandardsUserInteractionAndConductPolicy,
      ),
      _DocItem(
        section: 'legal_documents.seller_consumer',
        title: 'legal_documents.selling_practices',
        path: AppStrings.sellingPracticesPolicy,
      ),
      _DocItem(
        section: 'legal_documents.seller_consumer',
        title: 'legal_documents.refund_cancellation',
        path: AppStrings.refundAndCancellationPolicy,
      ),
      _DocItem(
        section: 'legal_documents.seller_consumer',
        title: 'legal_documents.dispute_resolution',
        path: AppStrings.sellOutDisputeResolutionPolicy,
      ),
      _DocItem(
        section: 'legal_documents.intellectual_property',
        title: 'legal_documents.ip_copyright',
        path: AppStrings.intellectualPropertyAndCopyrightPolicy,
      ),
    ];

    _filteredDocuments = List<_DocItem>.from(_allDocuments);

    _searchController.addListener(() {
      final String query = _searchController.text.toLowerCase().trim();

      setState(() {
        if (query.isEmpty) {
          _filteredDocuments = List<_DocItem>.from(_allDocuments);
        } else {
          _filteredDocuments = _allDocuments.where((_DocItem doc) {
            final String title = doc.title.tr().toLowerCase();
            return title.contains(query);
          }).toList();
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    Map<String, List<_DocItem>> grouped = <String, List<_DocItem>>{};
    for (_DocItem doc in _filteredDocuments) {
      grouped.putIfAbsent(doc.section, () => <_DocItem>[]);
      grouped[doc.section]!.add(doc);
    }

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(titleKey: 'legal_documents.title'.tr()),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            CustomTextFormField(
              controller: _searchController,
              hint: 'legal_documents.search'.tr(),
            ),
            const SizedBox(height: 20),

            for (String section in grouped.keys) ...<Widget>[
              _SectionHeader(title: section.tr(), text: text),
              for (_DocItem doc in grouped[section]!)
                _DocumentTile(title: doc.title.tr(), filePath: doc.path),
            ],
          ],
        ),
      ),
    );
  }
}

class _DocItem {
  _DocItem({required this.section, required this.title, required this.path});
  final String section;
  final String title;
  final String path;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.text});
  final String title;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.title, required this.filePath});
  final String title;
  final String filePath;

  void _openPdf(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<PdfViewerScreen>(
        builder: (_) => PdfViewerScreen(title: title, assetPath: filePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: text.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(width: 12),
          CustomElevatedButton(
            isLoading: false,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            onTap: () => _openPdf(context),
            title: 'legal_documents.read'.tr(),
            textStyle: text.labelMedium?.copyWith(color: color.onError),
          ),
        ],
      ),
    );
  }
}
