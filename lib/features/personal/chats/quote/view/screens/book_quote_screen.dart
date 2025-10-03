import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../core/widgets/calender/create_booking_widgets/widgets/create_booking_calender.dart';
import '../../../../../../core/widgets/calender/create_booking_widgets/widgets/create_booking_slots_with_slot_entity.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../business/core/data/sources/local_business.dart';
import '../../../../../business/core/data/sources/service/local_service.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../business/core/domain/entity/routine_entity.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../visits/view/book_visit/widgets/booking_profile_image.dart';
import '../../domain/entites/service_employee_entity.dart';
import '../provider/quote_provider.dart';

class BookQuoteScreen extends StatefulWidget {
  const BookQuoteScreen({required this.serviceEmployee, super.key});
  final ServiceEmployeeEntity serviceEmployee;

  @override
  State<BookQuoteScreen> createState() => _BookQuoteScreenState();
}

class _BookQuoteScreenState extends State<BookQuoteScreen> {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String? selectedTime;
  bool isLoadingBusiness = true;
  String? businessError;
  BusinessEntity? business;
  ServiceEntity? serviceEntity;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadBusinessAndService();
  }

  /// 🔹 Load business & service, then fetch slots
  Future<void> _loadBusinessAndService() async {
    try {
      serviceEntity =
          await LocalService().getService(widget.serviceEmployee.serviceId);
      if (serviceEntity != null) {
        business = await LocalBusiness().getBusiness(serviceEntity!.businessID);
      }
      await _fetchSlotsForDate(selectedDate);
    } catch (e) {
      businessError = 'Failed to load business details';
    }
    setState(() => isLoadingBusiness = false);
  }

  /// 🔹 Fetch slots for given date
  Future<void> _fetchSlotsForDate(DateTime date) async {
    if (business == null || serviceEntity == null) return;

    final RoutineEntity? routine = _routineForDate(date);
    final QuoteProvider slotsProvider =
        Provider.of<QuoteProvider>(context, listen: false);

    final String openingTime =
        (routine?.isOpen ?? false) ? (routine?.opening ?? '') : '';
    final String closingTime =
        (routine?.isOpen ?? false) ? (routine?.closing ?? '') : '';

    if (openingTime.isEmpty || closingTime.isEmpty) {
      slotsProvider.clearSlots();
      return;
    }

    try {
      await slotsProvider.fetchSlots(
        serviceId: serviceEntity!.serviceID,
        date: date,
        openingTime: openingTime,
        closingTime: closingTime,
        serviceDuration: serviceEntity!.time,
      );
    } catch (e) {}
  }

  RoutineEntity? _routineForDate(DateTime date) {
    final List<RoutineEntity>? routineList = business?.routine;
    if (routineList == null || routineList.isEmpty) return null;
    for (final RoutineEntity r in routineList) {
      if (r.day.weekday == date.weekday) return r;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingBusiness) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (businessError != null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const AppBarTitle(titleKey: 'request_quote'),
        ),
        body: Center(child: Text(businessError!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(titleKey: 'request_quote'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<QuoteProvider>(
          builder: (BuildContext context, QuoteProvider slotsProvider, _) {
            return Column(
              children: <Widget>[
                ProductImageWidget(
                  image: serviceEntity?.thumbnailURL ?? '',
                ),

                /// 🔹 Date picker
                CreateBookingCalender(
                  initialDate: selectedDate,
                  onDateChanged: (DateTime date) async {
                    setState(() {
                      selectedDate = date;
                      selectedTime = null;
                    });
                    await _fetchSlotsForDate(date);
                  },
                ),

                /// 🔹 Slots
                if (slotsProvider.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (slotsProvider.slots.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('No slots available for this day'),
                  )
                else
                  CreateBookingSlotsWithEntity(
                    slots: slotsProvider.slots,
                    selectedTime: selectedTime,
                    onSlotSelected: (String? time) =>
                        setState(() => selectedTime = time),
                    isLoading: false,
                  ),
                CustomElevatedButton(
                  isLoading: false,
                  onTap: () {
                    if (selectedTime == null) {
                      AppSnackBar.showSnackBar(context, 'select_slot'.tr());
                      return;
                    }

                    final DateTime slotDateTime =
                        _combineDateTime(selectedDate, selectedTime!);

                    final ServiceEmployeeEntity updatedService =
                        widget.serviceEmployee.copyWith(
                      quantity: quantity,
                      bookAt:
                          '${_format12Hour(slotDateTime)} ${slotDateTime.toIso8601String().split('T')[0]}',
                    );
                    Provider.of<QuoteProvider>(context, listen: false)
                        .updateService(updatedService);
                    Navigator.pop(context);
                  },
                  title: 'request_quote'.tr(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  DateTime _combineDateTime(DateTime date, String time12h) {
    final DateTime time = DateFormat.jm().parse(time12h);
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String _format12Hour(DateTime dateTime) {
    return DateFormat.jm().format(dateTime); // e.g., 12:00 PM
  }
}
