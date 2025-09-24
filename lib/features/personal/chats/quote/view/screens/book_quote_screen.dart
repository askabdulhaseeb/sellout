import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/routine/day_type.dart';
import '../../../../../../core/widgets/calender/create_booking_widgets/widgets/create_booking_calender.dart';
import '../../../../../../core/widgets/calender/create_booking_widgets/widgets/create_booking_slots_with_slot_entity.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../business/core/data/sources/local_business.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../business/core/domain/entity/routine_entity.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../visits/view/book_visit/widgets/booking_profile_image.dart';
import '../provider/quote_provider.dart';

class BookQuoteScreen extends StatefulWidget {
  const BookQuoteScreen({required this.service, super.key});
  final ServiceEntity service;

  @override
  State<BookQuoteScreen> createState() => _BookQuoteScreenState();
}

class _BookQuoteScreenState extends State<BookQuoteScreen> {
  String? selectedTime = '';
  bool isLoadingBusiness = true;
  BusinessEntity? business;

  @override
  void initState() {
    super.initState();
    _loadBusiness();
  }

  Future<void> _loadBusiness() async {
    business = await LocalBusiness().getBusiness(widget.service.businessID);
    setState(() => isLoadingBusiness = false);
  }

  RoutineEntity _routineForDate(DateTime date) {
    if (business?.routine == null || business!.routine!.isEmpty) {
      return RoutineEntity(isOpen: false, day: DayType.sunday);
    }
    return business!.routine!.firstWhere(
      (RoutineEntity r) => r.day.weekday == date.weekday,
      orElse: () => RoutineEntity(isOpen: false, day: DayType.sunday),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingBusiness) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(titleKey: 'book_quote'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<QuoteProvider>(
          builder: (BuildContext context, QuoteProvider slotsProvider, _) {
            return Column(
              children: <Widget>[
                ProductImageWidget(
                  image: widget.service.thumbnailURL ?? '',
                ),
                CreateBookingCalender(
                  initialDate: DateTime.now(),
                  onDateChanged: (DateTime date) async {
                    debugPrint('📅 Date selected: $date');
                    final RoutineEntity routine = _routineForDate(date);
                    final String openingTime =
                        routine.isOpen ? (routine.opening ?? '') : '';
                    final String closingTime =
                        routine.isOpen ? (routine.closing ?? '') : '';

                    if (openingTime.isEmpty || closingTime.isEmpty) {
                      slotsProvider.clearSlots();
                    } else {
                      await slotsProvider.fetchSlots(
                        serviceId: widget.service.serviceID,
                        date: date,
                        openingTime: openingTime,
                        closingTime: closingTime,
                        serviceDuration: widget.service.time,
                      );
                    }

                    debugPrint('🕒 Slots fetched: ${slotsProvider.slots}');
                  },
                ),
                CreateBookingSlotsWithEntity(
                  slots: slotsProvider.slots,
                  selectedTime: selectedTime,
                  onSlotSelected: (String? time) =>
                      setState(() => selectedTime = time),
                  isLoading: slotsProvider.isLoading,
                ),
                CustomElevatedButton(
                  isLoading: false,
                  onTap: () {
                    debugPrint('Selected slot: $selectedTime');
                    if (selectedTime == null || selectedTime!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please select a time slot')),
                      );
                      return;
                    }
                    // Here you can add logic to book/request the quote
                  },
                  title: 'request_quote',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
