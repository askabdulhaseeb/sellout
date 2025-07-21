import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../providers/marketplace_provider.dart';
import 'package:easy_localization/easy_localization.dart';

void showPrivateSearchDialog(BuildContext context) {
  final pro = Provider.of<MarketPlaceProvider>(context, listen: false);

  // String searchType = 'Product';

  showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
              const SizedBox(height: 10),
              Text(
                'private'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('${'username'.tr()}:'),
              ),
              const SizedBox(height: 6),
              CustomTextFormField(
                controller: pro.usernameController,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('${'access_code'.tr()}:'),
              ),
              const SizedBox(height: 6),
              CustomTextFormField(
                controller: pro.accessCodeController,
              ),
              const SizedBox(height: 20),
              // Container(
              //   padding: const EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: Colors.grey.shade50,
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(color: Colors.grey.shade300),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: <Widget>[
              //       Text('Search type:'.tr()),
              //       Row(
              //         children: <Widget>[
              //           Radio<String>(
              //             value: 'Product',
              //             groupValue: searchType,
              //             onChanged: (String? value) {
              //               searchType = value!;
              //             },
              //           ),
              //           Text('Product'.tr()),
              //           Radio<String>(
              //             value: 'Bid',
              //             groupValue: searchType,
              //             onChanged: (String? value) {
              //               searchType = value!;
              //             },
              //           ),
              //           Text('Bid'.tr()),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 20),
              CustomElevatedButton(
                isLoading: false,
                onTap: () {
                  pro.loadPosts(); // use accessCode/username/searchType as needed
                },
                title: 'start_search'.tr(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
