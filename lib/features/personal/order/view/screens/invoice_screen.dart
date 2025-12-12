import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/order_entity.dart';
import '../../../../../../core/functions/app_log.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({required this.order, super.key});

  final OrderEntity order;

  static Route route(OrderEntity order) =>
      MaterialPageRoute(builder: (_) => InvoiceScreen(order: order));

  Future<void> _generateAndSavePdf(BuildContext context) async {
    try {
      final pw.Document doc = pw.Document();

      doc.addPage(
        pw.Page(
          build: (pw.Context ctx) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text('Invoice', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 12),
              pw.Text('Order: ${order.orderId}'),
              pw.Text('Buyer: ${order.buyerId}'),
              pw.Text('Total: ${order.totalAmount.toStringAsFixed(2)}'),
              pw.SizedBox(height: 12),
              pw.Text('Items:'),
              // Minimal line per item (if post title available)
              pw.Bullet(text: order.postId),
            ],
          ),
        ),
      );

      final List<int> bytes = await doc.save();

      // Save to Downloads on Android or app documents on other platforms
      final String fileName = 'invoice_${order.orderId}.pdf';
      File file;
      if (Platform.isAndroid) {
        final String downloadsPath = '/storage/emulated/0/Download';
        file = File('$downloadsPath/$fileName');
        await file.writeAsBytes(bytes);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        file = File('${dir.path}/$fileName');
        await file.writeAsBytes(bytes);
      }

      AppLog.info('Invoice saved: ${file.path}');

      // Try to preview using Printing
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => Uint8List.fromList(bytes),
      );
    } catch (e, st) {
      AppLog.error('Failed to generate invoice PDF', error: e, stackTrace: st);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate invoice')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('invoice'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Order ID: ${order.orderId}'),
            const SizedBox(height: 8),
            Text('Buyer ID: ${order.buyerId}'),
            const SizedBox(height: 8),
            Text('Amount: ${order.totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export as PDF'),
              onPressed: () => _generateAndSavePdf(context),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:printing/printing.dart';
// import 'dart:typed_data';
// import '../../domain/entities/order_entity.dart';

// class InvoiceScreen extends StatefulWidget {
//   const InvoiceScreen({required this.order, super.key});
//   final OrderEntity order;

//   @override
//   State<InvoiceScreen> createState() => _InvoiceScreenState();
// }

// class _InvoiceScreenState extends State<InvoiceScreen> {
//   late Future<Uint8List> _pdfFuture;

//   @override
//   void initState() {
//     super.initState();
//     _pdfFuture = _generateInvoicePDF(widget.order); // generate PDF immediately
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Invoice'),
//       ),
//       body: FutureBuilder<Uint8List>(
//         future: _pdfFuture,
//         builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError || !snapshot.hasData) {
//             return const Center(child: Text('Error generating PDF'));
//           }

//           final Uint8List pdfBytes = snapshot.data!;

//           return Column(
//             children: <Widget>[
//               Expanded(
//                 child: PdfPreview(
//                   build: (PdfPageFormat format) async => pdfBytes,
//                   allowPrinting: false,
//                   allowSharing: false,
//                   canChangeOrientation: false,
//                   canChangePageFormat: false,
//                   initialPageFormat: PdfPageFormat.a4,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ElevatedButton.icon(
//                   onPressed: () async {
//                     await Printing.sharePdf(
//                       bytes: pdfBytes,
//                       filename: 'invoice_${widget.order.orderId}.pdf',
//                     );
//                   },
//                   icon: const Icon(Icons.download),
//                   label: const Text('Download PDF'),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Future<Uint8List> _generateInvoicePDF(OrderEntity order) async {
//     final pw.Document pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(24),
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: <pw.Widget>[
//               // HEADER
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: <pw.Widget>[
//                   pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: <pw.Widget>[
//                       pw.Text(
//                         'Invoice #${order.orderId}',
//                         style: pw.TextStyle(
//                             fontSize: 18, fontWeight: pw.FontWeight.bold),
//                       ),
//                       pw.Text(
//                         'Transaction ID: ${order.paymentDetail.paymentIndentId}',
//                         style: const pw.TextStyle(fontSize: 12),
//                       ),
//                     ],
//                   ),
//                   pw.Container(
//                     padding: const pw.EdgeInsets.all(6),
//                     decoration: pw.BoxDecoration(
//                       color: PdfColors.green,
//                       borderRadius: pw.BorderRadius.circular(4),
//                     ),
//                     child: pw.Text(
//                       'NEW',
//                       style: pw.TextStyle(
//                           color: PdfColors.white,
//                           fontWeight: pw.FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 16),

//               // TO Section
//               pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: <pw.Widget>[
//                   pw.Text(
//                     order.shippingAddress.recipientName,
//                     style: pw.TextStyle(
//                         fontSize: 14, fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.Text(
//                     '${order.shippingAddress.address1}, ${order.shippingAddress.city}, ${order.shippingAddress.state}, ${order.shippingAddress.postalCode}',
//                   ),
//                   pw.Text(order.shippingAddress.phoneNumber),
//                   pw.Text('Email: example@example.com'),
//                 ],
//               ),
//               pw.SizedBox(height: 16),

//               // TABLE
//               pw.Table.fromTextArray(
//                 headers: <dynamic>['DESCRIPTION', 'RATE', 'QTY', 'SUBTOTAL'],
//                 data: <List<dynamic>>[
//                   <dynamic>[
//                     'Item ${order.postId}',
//                     '${order.paymentDetail.postCurrency}${order.price.toStringAsFixed(2)}',
//                     '${order.quantity}',
//                     '${order.paymentDetail.postCurrency}${order.totalAmount.toStringAsFixed(2)}',
//                   ],
//                 ],
//                 headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                 headerDecoration:
//                     const pw.BoxDecoration(color: PdfColors.grey300),
//                 cellAlignment: pw.Alignment.centerLeft,
//                 columnWidths: <int, pw.TableColumnWidth>{
//                   0: const pw.FlexColumnWidth(4),
//                   1: const pw.FlexColumnWidth(2),
//                   2: const pw.FlexColumnWidth(1),
//                   3: const pw.FlexColumnWidth(2),
//                 },
//               ),
//               pw.SizedBox(height: 12),

//               // TOTALS
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.end,
//                 children: <pw.Widget>[
//                   pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: <pw.Widget>[
//                       pw.Text(
//                           'Subtotal: ${order.paymentDetail.postCurrency}${order.price.toStringAsFixed(2)}'),
//                       pw.Text('Discount: 0%'),
//                       pw.Text('Tax: 0'),
//                       pw.Text(
//                         'GRAND TOTAL: ${order.paymentDetail.postCurrency}${order.totalAmount.toStringAsFixed(2)}',
//                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 24),

//               // FOOTER
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: <pw.Widget>[
//                   pw.Text('Sign: __________________'),
//                   pw.Text(
//                     'Visit: www.example.com/invoice/${order.orderId}',
//                     style: const pw.TextStyle(
//                         color: PdfColors.blue,
//                         decoration: pw.TextDecoration.underline),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     return pdf.save();
//   }
// }
