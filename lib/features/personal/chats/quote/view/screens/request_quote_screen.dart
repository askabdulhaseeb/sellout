import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/loaders/loader_container.dart';
import '../../../../../business/core/data/sources/local_business.dart';
import '../../../../../business/core/data/sources/service/local_service.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../data/models/service_employee_model.dart';
import '../provider/quote_provider.dart';
import '../widgets/step_indicator.dart';
import 'pages/services_step.dart';
import 'pages/step_booking.dart';
import 'pages/step_review.dart';

class RequestQuoteScreen extends StatefulWidget {
  const RequestQuoteScreen({required this.businessId, super.key});
  final String businessId;

  @override
  State<RequestQuoteScreen> createState() => _RequestQuoteScreenState();
}

class _RequestQuoteScreenState extends State<RequestQuoteScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BusinessEntity?>(
      future: LocalBusiness().getBusiness(widget.businessId),
      builder: (BuildContext context, AsyncSnapshot<BusinessEntity?> snapshot) {
        final BusinessEntity? business = snapshot.data;
        return Scaffold(
          appBar: AppBar(title: Text('request_quote'.tr()), centerTitle: true),
          body: Column(
            children: <Widget>[
              StepIndicator(currentStep: _currentStep),
              const Divider(),
              Expanded(
                child: Consumer<QuoteProvider>(
                  builder: (BuildContext context, QuoteProvider pro, _) {
                    if (_currentStep == 0) {
                      return StepServices(businessId: widget.businessId);
                    } else if (_currentStep == 1) {
                      return const StepBooking();
                    } else {
                      return const StepReview();
                    }
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                if (_currentStep > 0)
                  Expanded(
                    child: CustomElevatedButton(
                      isLoading: false,
                      onTap: () => setState(() => _currentStep--),
                      title: 'back'.tr(),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  child: CustomElevatedButton(
                      isLoading: false,
                      onTap: () {
                        if (_currentStep < 2) {
                          setState(() => _currentStep++);
                        } else {
                          Provider.of<QuoteProvider>(context, listen: false)
                              .requestQuote(
                                  business?.businessID ?? '', context);
                        }
                      },
                      title: _currentStep == 2 ? 'submit'.tr() : 'next'.tr()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ✅ Service Tile (Selected)
class RequestQuoteTile extends StatelessWidget {
  const RequestQuoteTile({required this.selected, super.key});
  final ServiceEmployeeModel selected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ServiceEntity?>(
      future: LocalService().getService(selected.serviceId),
      builder: (BuildContext context, AsyncSnapshot<ServiceEntity?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoaderContainer(
              height: 80, width: double.infinity, borderRadius: 12);
        }
        if (!snapshot.hasData) return const SizedBox.shrink();

        final ServiceEntity service = snapshot.data!;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorScheme.of(context).outlineVariant),
          ),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CustomNetworkImage(
                    imageURL: service.thumbnailURL,
                    placeholder: service.name,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(service.name,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(width: 6),
                        Text('x ${selected.quantity}'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(selected.bookAt),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  context
                      .read<QuoteProvider>()
                      .removeService(selected.serviceId);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
