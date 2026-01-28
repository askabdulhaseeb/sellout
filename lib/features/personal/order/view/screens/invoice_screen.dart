import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../core/constants/app_spacings.dart';
import '../../../../../core/widgets/text_display/sellout_title.dart';
import '../../domain/entities/order_entity.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../auth/signin/domain/entities/address_entity.dart';
import '../../../post/data/sources/local/local_post.dart';
import '../../../post/domain/entities/post/post_entity.dart';
import '../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../business/core/data/sources/local_business.dart';
import '../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../../core/utilities/app_string.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({required this.order, super.key});

  final OrderEntity order;

  static Route<void> route(OrderEntity order) =>
      MaterialPageRoute<void>(builder: (_) => InvoiceScreen(order: order));

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final GlobalKey _invoiceKey = GlobalKey();

  bool _isLoading = true;
  String? _errorMessage;
  bool _isSaving = false;

  PostEntity? _post;
  UserEntity? _buyerUser;
  UserEntity? _sellerUser;
  BusinessEntity? _sellerBusiness;

  @override
  void initState() {
    super.initState();
    _loadLocalRelatedData();
  }

  Future<void> _loadLocalRelatedData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final PostEntity? post = await LocalPost().getPost(widget.order.postId);
      final UserEntity? buyer = await LocalUser().user(widget.order.buyerId);

      UserEntity? sellerUser;
      BusinessEntity? sellerBusiness;

      if (widget.order.businessId.isNotEmpty) {
        sellerBusiness = await LocalBusiness().getBusiness(
          widget.order.businessId,
        );
      } else if (widget.order.sellerId.toUpperCase().startsWith('BU')) {
        sellerBusiness = await LocalBusiness().getBusiness(
          widget.order.sellerId,
        );
      } else {
        sellerUser = await LocalUser().user(widget.order.sellerId);
      }

      if (!mounted) return;
      setState(() {
        _post = post;
        _buyerUser = buyer;
        _sellerUser = sellerUser;
        _sellerBusiness = sellerBusiness;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'failed_to_load_invoice_data'.tr();
        _isLoading = false;
      });
      AppLog.error('Error loading invoice data', error: e);
    }
  }

  String _formatCurrency(double amount, {String? currencyCode}) {
    final String code = currencyCode ?? widget.order.paymentDetail.postCurrency;
    final String symbol = CountryHelper.currencySymbolHelper(code);
    final String formattedAmount = amount.toStringAsFixed(2);

    final List<String> parts = formattedAmount.split('.');
    final String integerPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );

    if (symbol == 'na') {
      return '$code $integerPart.${parts[1]}';
    }
    return '$symbol$integerPart.${parts[1]}';
  }

  Future<Directory> _getInvoiceSaveDirectory() async {
    if (Platform.isAndroid) {
      // App-specific external storage (scoped-storage safe, no runtime permission).
      final Directory? dir = await getExternalStorageDirectory();
      if (dir != null) return dir;
    }
    return getApplicationDocumentsDirectory();
  }

  Future<bool> _saveToGallery(
    Uint8List pngBytes, {
    required String title,
  }) async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) return false;

    try {
      final String safeTitle = title.replaceAll(
        RegExp(r'\.(png|jpg|jpeg)$', caseSensitive: false),
        '',
      );
      await PhotoManager.editor.saveImage(
        filename: safeTitle,
        pngBytes,
        title: safeTitle,
      );
      return true;
    } catch (e, st) {
      AppLog.error(
        'Failed to save invoice to gallery',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  String _compactId(String value, {int start = 10, int end = 6}) {
    final String trimmed = value.trim();
    if (trimmed.length <= start + end + 1) return trimmed;
    return '${trimmed.substring(0, start)}…${trimmed.substring(trimmed.length - end)}';
  }

  List<String> _addressLines(
    AddressEntity? address, {
    required String fallbackName,
  }) {
    final List<String> lines = <String>[];

    final String resolvedName = (address?.recipientName ?? '').trim().isNotEmpty
        ? address!.recipientName
        : fallbackName;
    if (resolvedName.trim().isNotEmpty) {
      lines.add(resolvedName.trim());
    }

    void addIfNotEmpty(String value) {
      final String v = value.trim();
      if (v.isNotEmpty) lines.add(v);
    }

    addIfNotEmpty(address?.address1 ?? '');
    addIfNotEmpty(address?.address2 ?? '');

    final String cityPostal = <String?>[address?.city, address?.postalCode]
        .whereType<String>()
        .map((String e) => e.trim())
        .where((String e) => e.isNotEmpty)
        .join(' ');
    addIfNotEmpty(cityPostal);

    final String stateCountry =
        <String?>[address?.state.stateName, address?.country.countryName]
            .whereType<String>()
            .map((String e) => e.trim())
            .where((String e) => e.isNotEmpty)
            .join(', ');
    addIfNotEmpty(stateCountry);

    if (lines.isEmpty) return <String>[fallbackName];
    return lines;
  }

  List<String> _getToAddressLines() {
    final AddressEntity toAddress =
        widget.order.shippingDetails?.toAddress ?? widget.order.shippingAddress;
    final String fallbackName =
        _buyerUser?.displayName ?? widget.order.shippingAddress.recipientName;
    return _addressLines(toAddress, fallbackName: fallbackName);
  }

  List<String> _getFromAddressLines() {
    final String sellerName =
        _sellerBusiness?.displayName ??
        _sellerUser?.displayName ??
        widget.order.sellerId;

    final AddressEntity? fromAddress =
        widget.order.shippingDetails?.fromAddress;
    if (fromAddress == null) {
      return <String>[sellerName];
    }

    return _addressLines(fromAddress, fallbackName: sellerName);
  }

  Future<void> _showInvoiceGlassPreview({
    required File file,
    required String title,
  }) async {
    if (!mounted) return;

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).closeButtonTooltip,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (BuildContext context, _, _) {
        final ThemeData theme = Theme.of(context);

        const Duration receiptAnimDuration = Duration(milliseconds: 420);

        return SafeArea(
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: <Widget>[
                BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: const SizedBox.expand(),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: theme.dividerColor),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 18,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: receiptAnimDuration,
                          curve: Curves.easeOutCubic,
                          builder:
                              (BuildContext context, double t, Widget? child) {
                                return Opacity(
                                  opacity: t,
                                  child: Transform.translate(
                                    offset: Offset(0, (1 - t) * 18),
                                    child: Transform.scale(
                                      scale: 0.98 + (0.02 * t),
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                          child: _ReceiptSuccessCard(
                            theme: theme,
                            file: file,
                            successText: 'invoice_saved_successfully'.tr(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            final Animation<double> curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(curved),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.985, end: 1.0).animate(curved),
                  child: child,
                ),
              ),
            );
          },
    );
  }

  Future<void> _captureAndSavePng() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final RenderRepaintBoundary? boundary =
          _invoiceKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('Could not capture invoice');
      }

      const double pixelRatio = 3.0;
      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Failed to convert image to bytes');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final String fileName = 'invoice_${widget.order.orderId}.png';

      final Directory dir = await _getInvoiceSaveDirectory();
      final File file = File('${dir.path}/$fileName');
      await file.writeAsBytes(pngBytes, flush: true);

      final bool savedToGallery = await _saveToGallery(
        pngBytes,
        title: fileName,
      );

      if (!savedToGallery) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('photos_permission_required'.tr()),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      AppLog.info('Invoice image saved to gallery and cached at: ${file.path}');

      if (!mounted) return;
      await _showInvoiceGlassPreview(
        file: file,
        title: 'invoice_saved_successfully'.tr(),
      );
    } catch (e, st) {
      AppLog.error(
        'Failed to capture/save invoice image',
        error: e,
        stackTrace: st,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: <Widget>[
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('failed_to_save_invoice'.tr())),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
        ),
        title: Text('order_invoice'.tr()),
      ),
      body: SafeArea(child: _buildBody(theme, isDark)),
    );
  }

  Widget _buildBody(ThemeData theme, bool isDark) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 12),
            Text(_errorMessage!, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _loadLocalRelatedData,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text('retry'.tr()),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Center(
            child: RepaintBoundary(
              key: _invoiceKey,
              child: _buildInvoiceCard(isDark),
            ),
          ),
          const SizedBox(height: 12),
          _buildActionsRow(),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard(bool isDark) {
    final ThemeData theme = Theme.of(context);
    final String dateLabel = DateFormat(
      'dd MMM yyyy',
    ).format(widget.order.createdAt);
    final Color cardColor = theme.colorScheme.surface;
    final Color borderColor = Theme.of(context).dividerColor;
    final Color mutedText = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final Color mainText = theme.colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Header Row (logo left, invoice info right) + small info boxes
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Logo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        AppStrings.selloutLogo,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SellOutTitle(
                      size: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'invoice'.tr().toUpperCase(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          dateLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: mutedText,
                          ),
                        ),
                      ],
                    ),
                    // Invoice title + Order info
                  ],
                ),

                const SizedBox(height: 10),

                // Order ID (simple, no tax)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'order_id'.tr(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _compactId(widget.order.orderId),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: mainText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: borderColor),

          // Addresses Row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // To
                Expanded(
                  child: _buildAddressBlock(
                    title: 'to'.tr(),
                    lines: _getToAddressLines(),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 16),
                // From
                Expanded(
                  child: _buildAddressBlock(
                    title: 'from'.tr(),
                    lines: _getFromAddressLines(),
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),

          // Items Table
          _buildItemsTable(isDark, borderColor),

          // Totals Section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                // Payment method
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'payment'.tr(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: mutedText,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.order.paymentDetail.method,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.grey.shade200
                              : Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                // Totals
                _buildTotalsColumn(isDark),
              ],
            ),
          ),

          Divider(height: 1, color: borderColor),

          // Footer text only (actions are outside RepaintBoundary so they
          // don't appear in the saved image).
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'thank_you_for_purchase'.tr(),
              style: TextStyle(fontSize: 11, color: mutedText),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsRow() {
    final ThemeData theme = Theme.of(context);
    final Color mutedText = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            'download'.tr(),
            style: TextStyle(fontSize: 11, color: mutedText),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 34,
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _captureAndSavePng,
            icon: _isSaving
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : const Icon(Icons.download_outlined, size: 15),
            label: Text(
              _isSaving ? 'saving'.tr() : 'save'.tr(),
              style: const TextStyle(fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressBlock({
    required String title,
    required List<String> lines,
    required bool isDark,
  }) {
    final Color mutedText = isDark
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: mutedText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        ...lines.map(
          (String line) => Text(
            line,
            style: TextStyle(fontSize: 12, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsTable(bool isDark, Color borderColor) {
    final Color headerBg = isDark ? Colors.grey.shade800 : Colors.grey.shade50;
    final Color mutedText = isDark
        ? Colors.grey.shade400
        : Colors.grey.shade600;
    final Color mainText = isDark ? Colors.grey.shade200 : Colors.grey.shade800;
    final ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: headerBg,
            border: Border.symmetric(
              horizontal: BorderSide(color: borderColor),
            ),
          ),
          child: Row(
            spacing: AppSpacing.hSm,
            children: <Widget>[
              Expanded(
                child: Text(
                  'item'.tr(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: mutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  maxLines: 1,
                  'quantity'.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: mutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'price'.tr(),
                  textAlign: TextAlign.right,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: mutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'amount'.tr(),
                  textAlign: TextAlign.right,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: mutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Item Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            spacing: AppSpacing.hSm,
            children: <Widget>[
              Expanded(
                child: Text(
                  _post?.title ?? widget.order.postId,
                  style: TextStyle(fontSize: 12, color: mainText),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  '${widget.order.quantity}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: mainText),
                ),
              ),
              Expanded(
                child: Text(
                  _formatCurrency(widget.order.price),
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12, color: mainText),
                ),
              ),
              Expanded(
                child: Text(
                  _formatCurrency(widget.order.price * widget.order.quantity),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12,
                    color: mainText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalsColumn(bool isDark) {
    final Color mutedText = isDark
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    final double subtotal = widget.order.price * widget.order.quantity;
    final double shipping = widget.order.paymentDetail.deliveryPrice;
    final double total = widget.order.totalAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _buildTotalLine('subtotal'.tr(), _formatCurrency(subtotal), mutedText),
        const SizedBox(height: 4),
        _buildTotalLine(
          'postage_fee'.tr(),
          _formatCurrency(shipping),
          mutedText,
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'grand_total'.tr(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.red.shade300 : Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _formatCurrency(total),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.red.shade300 : Colors.red.shade700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalLine(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(label, style: TextStyle(fontSize: 11, color: color)),
        const SizedBox(width: 12),
        Text(value, style: TextStyle(fontSize: 11, color: color)),
      ],
    );
  }
}

class _PreviewCardShell extends StatelessWidget {
  const _PreviewCardShell({required this.theme, this.child});

  final ThemeData theme;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

class _ReceiptSuccessCard extends StatelessWidget {
  const _ReceiptSuccessCard({
    required this.theme,
    required this.file,
    required this.successText,
  });

  final ThemeData theme;
  final File file;
  final String successText;

  @override
  Widget build(BuildContext context) {
    final Color mutedText = theme.colorScheme.onSurface.withValues(alpha: 0.65);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        successText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'order_invoice'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _DashedLine(
              color: theme.dividerColor.withValues(alpha: 0.9),
            ),
          ),
          _PreviewCardShell(
            theme: theme,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                file,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'failed_to_load_invoice_data'.tr(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double dashWidth = 7;
        const double dashGap = 5;
        final int dashCount = (constraints.maxWidth / (dashWidth + dashGap))
            .floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(dashCount, (int _) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}
