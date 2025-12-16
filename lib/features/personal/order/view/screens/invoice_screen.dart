import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../core/widgets/sellout_title.dart';
import '../../domain/entities/order_entity.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
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

      AppLog.info('Invoice image saved: ${file.path}');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: <Widget>[
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('invoice_saved_successfully'.tr())),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Show an in-app preview (receipt-style) after download.
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => _InvoiceDownloadedPreviewScreen(
            file: file,
            title: 'invoice_saved_successfully'.tr(),
          ),
        ),
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
    final Color mutedText = theme.colorScheme.onSurface.withOpacity(0.6);
    final Color mainText = theme.colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SellOutTitle(
                      size: 20,
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

                const SizedBox(height: 12),

                // Small info boxes (INFO / TAX ID)
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade900
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'info'.tr(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: mutedText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.order.orderId,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: mainText,
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade900
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'tax_id'.tr(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: mutedText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.order.paymentDetail.paymentIndentId,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: mainText,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: borderColor),

          // Addresses Row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Bill To
                Expanded(
                  child: _buildAddressBlock(
                    title: 'bill_to'.tr(),
                    lines: _getBuyerAddressLines(),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 16),
                // From
                Expanded(
                  child: _buildAddressBlock(
                    title: 'from'.tr(),
                    lines: _getSellerAddressLines(),
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
            padding: const EdgeInsets.all(16),
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
    final Color mutedText = theme.colorScheme.onSurface.withOpacity(0.6);

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
          height: 32,
          child: OutlinedButton.icon(
            onPressed: _isSaving ? null : _captureAndSavePng,
            icon: _isSaving
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : const Icon(Icons.download_outlined, size: 16),
            label: Text(
              _isSaving ? 'saving'.tr() : 'save'.tr(),
              style: const TextStyle(fontSize: 12),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 32,
          child: OutlinedButton.icon(
            onPressed: _isSaving ? null : _captureAndSavePng,
            icon: const Icon(Icons.print_outlined, size: 16),
            label: Text('print'.tr(), style: const TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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

  List<String> _getBuyerAddressLines() {
    final String name =
        _buyerUser?.displayName ?? widget.order.shippingAddress.recipientName;
    final List<String> lines = <String>[name];

    if (widget.order.shippingAddress.address1.isNotEmpty) {
      lines.add(widget.order.shippingAddress.address1);
    }

    final List<String> cityStateParts = <String>[];
    if (widget.order.shippingAddress.city.isNotEmpty) {
      cityStateParts.add(widget.order.shippingAddress.city);
    }
    if (widget.order.shippingAddress.postalCode.isNotEmpty) {
      cityStateParts.add(widget.order.shippingAddress.postalCode);
    }
    if (cityStateParts.isNotEmpty) {
      lines.add(cityStateParts.join(' '));
    }

    if (widget.order.shippingAddress.country.countryName.isNotEmpty) {
      lines.add(widget.order.shippingAddress.country.countryName);
    }

    return lines;
  }

  List<String> _getSellerAddressLines() {
    final String name =
        _sellerBusiness?.displayName ??
        _sellerUser?.displayName ??
        widget.order.sellerId;
    return <String>[name];
  }

  Widget _buildItemsTable(bool isDark, Color borderColor) {
    final Color headerBg = isDark ? Colors.grey.shade800 : Colors.grey.shade50;
    final Color mutedText = isDark
        ? Colors.grey.shade400
        : Colors.grey.shade600;
    final Color mainText = isDark ? Colors.grey.shade200 : Colors.grey.shade800;
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: headerBg,
            border: Border.symmetric(
              horizontal: BorderSide(color: borderColor),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Text(
                  'item'.tr().toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: mutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  'quantity'.tr().toUpperCase(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: mutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 70,
                child: Text(
                  'price'.tr().toUpperCase(),
                  textAlign: TextAlign.right,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: mutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 80,
                child: Text(
                  'amount'.tr().toUpperCase(),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Text(
                  _post?.title ?? widget.order.postId,
                  style: TextStyle(fontSize: 12, color: mainText),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${widget.order.quantity}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: mainText),
                ),
              ),
              SizedBox(
                width: 70,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _formatCurrency(widget.order.price),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12, color: mainText),
                  ),
                ),
              ),
              SizedBox(
                width: 80,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _formatCurrency(widget.order.price * widget.order.quantity),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      color: mainText,
                      fontWeight: FontWeight.w500,
                    ),
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
              'grand_total'.tr().toUpperCase(),
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

class _InvoiceDownloadedPreviewScreen extends StatelessWidget {
  const _InvoiceDownloadedPreviewScreen({
    required this.file,
    required this.title,
  });

  final File file;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(elevation: 0, centerTitle: true, title: Text(title)),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                file,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    'failed_to_load_invoice_data'.tr(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
