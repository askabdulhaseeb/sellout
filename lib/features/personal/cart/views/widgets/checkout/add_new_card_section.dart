// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import '../../../../../../core/widgets/costom_textformfield.dart';
// import '../../../../../../core/widgets/custom_dropdown.dart';

// class SaveCardBottomSheet extends StatefulWidget {
//   const SaveCardBottomSheet({super.key});

//   @override
//   State<SaveCardBottomSheet> createState() => _SaveCardBottomSheetState();
// }

// class _SaveCardBottomSheetState extends State<SaveCardBottomSheet> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   String selectedCountry = 'USA';
//   bool isLoading = false;
//   final List<String> countryList = <String>[
//     'USA',
//     'Pak',
//     'UK',
//   ];

//   // Store the card details
//   CardDetails? _cardDetails;

//   void _saveCard() async {
//     setState(() => isLoading = true);

//     try {
//       // Ensure _cardDetails is not null
//       if (_cardDetails == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Card details are incomplete')),
//         );
//         return;
//       }

//       // Create PaymentMethod using the card details
//       final PaymentMethod paymentMethod =
//           await Stripe.instance.createPaymentMethod(
//         params: PaymentMethodParams.card(
//           paymentMethodData: PaymentMethodData(
//             billingDetails: BillingDetails(
//               name: nameController.text.trim(),
//               email: emailController.text.trim(),
//             ),
//           ),
//         ),
//       );

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Card saved: ${paymentMethod.id}')),
//       );

//       Navigator.pop(
//           context, paymentMethod); // Close the bottom sheet with payment method
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     emailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<DropdownMenuItem<String>> dropdownItems = countryList
//         .map((String country) => DropdownMenuItem<String>(
//               value: country,
//               child: Text(country),
//             ))
//         .toList();

//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           const Text(
//             'Securely add your card',
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//           const SizedBox(height: 20),

//           // Name Field
//           CustomTextFormField(
//             controller: nameController,
//             labelText: 'Full Name',
//             style: const TextStyle(fontSize: 16),
//           ),
//           const SizedBox(height: 12),

//           // Email Field
//           CustomTextFormField(
//             controller: emailController,
//             labelText: 'Email Address',
//             style: const TextStyle(fontSize: 16),
//           ),
//           const SizedBox(height: 12),

//           // Country Dropdown
//           CustomDropdown(
//             validator: (bool? value) => null,
//             title: 'Country',
//             selectedItem: selectedCountry,
//             items: dropdownItems,
//             onChanged: (String? value) =>
//                 setState(() => selectedCountry = value ?? ''),
//           ),
//           const SizedBox(height: 20),

//           // Card Input Box (CardFormField with custom style)
//           CardFormField(
//             onCardChanged: (CardFieldInputDetails? cardDetails) {
//               setState(() {
//                 _cardDetails = cardDetails; // Store the card details correctly
//               });
//             },
//             style: const TextStyle(fontSize: 16),

//           ),
//           const SizedBox(height: 20),

//           // Save Button
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               onPressed: isLoading ? null : _saveCard,
//               icon: const Icon(Icons.save, color: Colors.white),
//               label: isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text('Save Card', style: TextStyle(fontSize: 16)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),
//         ],
//       ),
//     );
//   }
// }
