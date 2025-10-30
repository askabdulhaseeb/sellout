import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class InAppWebViewPage extends StatefulWidget {
  const InAppWebViewPage({required this.url, super.key});
  final String url;

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  Future<void> _launchUrlInSheetView() async {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    try {
      await launchUrl(
        Uri.parse(widget.url),
        customTabsOptions: CustomTabsOptions.partial(
          configuration: PartialCustomTabsConfiguration.adaptiveSheet(
            initialHeight: mediaQuery.size.height * 0.7,
            initialWidth: mediaQuery.size.width * 0.4,
            activitySideSheetMaximizationEnabled: true,
            activitySideSheetDecorationType:
                CustomTabsActivitySideSheetDecorationType.shadow,
            activitySideSheetRoundedCornersPosition:
                CustomTabsActivitySideSheetRoundedCornersPosition.top,
            cornerRadius: 16,
          ),
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: theme.colorScheme.surface,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions.pageSheet(
          configuration: const SheetPresentationControllerConfiguration(
            detents: <SheetPresentationControllerDetent>{
              SheetPresentationControllerDetent.large,
              SheetPresentationControllerDetent.medium,
            },
            prefersScrollingExpandsWhenScrolledToEdge: true,
            prefersGrabberVisible: true,
            prefersEdgeAttachedInCompactHeight: true,
          ),
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening page: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), _launchUrlInSheetView);
  }

  @override
  Widget build(BuildContext context) {
    // The screen is just a placeholder, as the custom tab opens automatically
    return const SizedBox.shrink();
  }
}
