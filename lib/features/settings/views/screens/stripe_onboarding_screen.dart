import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class StripeOnboardingScreen extends StatefulWidget {
  final String url;
  const StripeOnboardingScreen({super.key, required this.url});

  @override
  State<StripeOnboardingScreen> createState() => _StripeOnboardingScreenState();
}

class _StripeOnboardingScreenState extends State<StripeOnboardingScreen> {
  Future<void> _openSecureStripeOnboarding() async {
    final Uri uri = Uri.parse(widget.url);

    try {
      await launchUrl(
        uri,
        customTabsOptions: CustomTabsOptions(
          browser: const CustomTabsBrowserConfiguration(
            prefersDefaultBrowser: true, // ✅ opens Chrome if available
          ),
          colorSchemes: CustomTabsColorSchemes.defaults(),
          showTitle: true,
          shareState: CustomTabsShareState.on,
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: Theme.of(context).colorScheme.surface,
          preferredControlTintColor: Theme.of(context).colorScheme.onSurface,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
          entersReaderIfAvailable: false,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open Stripe page: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // ✅ Delay ensures context is ready before calling
    Future.delayed(
        const Duration(milliseconds: 300), _openSecureStripeOnboarding);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
