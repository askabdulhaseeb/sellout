import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../post/domain/entities/visit/visiting_entity.dart';
import '../providers/visit_calender_provider.dart';

class VisitCalenderScreen extends StatefulWidget {
  const VisitCalenderScreen({super.key});
  static String routeName = 'visit-calender';

  @override
  State<VisitCalenderScreen> createState() => _VisitCalenderScreenState();
}

class _VisitCalenderScreenState extends State<VisitCalenderScreen> {
  late String postID;
  DateTime selectedDate = DateTime(2023, 7, 4);
  String selectedView = 'Day';
  String selectedFilter = 'All';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    postID = args?['pid'] ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<VisitCalenderProvider>(context, listen: false);
      provider.setPostId(postID);
      provider.getPostVisitings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('my_appointments'.tr())),
      body: Consumer<VisitCalenderProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                VisitCalendarFilters(
                  selectedDate: selectedDate,
                  selectedView: selectedView,
                  selectedFilter: selectedFilter,
                  onDateChanged: (date) => setState(() => selectedDate = date),
                  onViewChanged: (view) => setState(() => selectedView = view),
                  onFilterChanged: (filter) =>
                      setState(() => selectedFilter = filter),
                ),
                const Divider(height: 1),
                Expanded(
                  child: provider.loading
                      ? const Center(child: CircularProgressIndicator())
                      : VisitTimeline(
                          visits: provider.visits,
                          selectedDate: selectedDate,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VisitCalendarFilters extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedView;
  final String selectedFilter;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onViewChanged;
  final ValueChanged<String> onFilterChanged;

  const VisitCalendarFilters({
    super.key,
    required this.selectedDate,
    required this.selectedView,
    required this.selectedFilter,
    required this.onDateChanged,
    required this.onViewChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Date picker
          Expanded(
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) onDateChanged(picked);
              },
              child: Row(
                children: [
                  Text(DateFormat.yMMMMd().format(selectedDate)),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: selectedView,
            items: ['Day', 'Week', 'Month']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => v != null ? onViewChanged(v) : null,
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: selectedFilter,
            items: ['All', 'Upcoming', 'Past']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => v != null ? onFilterChanged(v) : null,
          ),
        ],
      ),
    );
  }
}

class VisitTimeline extends StatelessWidget {
  final List<VisitingEntity> visits;
  final DateTime selectedDate;

  const VisitTimeline({
    super.key,
    required this.visits,
    required this.selectedDate,
  });

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 24,
      itemBuilder: (context, hour) {
        final String timeLabel = '${hour.toString().padLeft(2, '0')}:00';

        final visitsAtHour = visits
            .where((v) =>
                v.dateTime.hour == hour && isSameDay(v.dateTime, selectedDate))
            .toList();

        final visit = visitsAtHour.isNotEmpty ? visitsAtHour.first : null;

        return SizedBox(
          height: 80,
          child: Stack(
            children: [
              Positioned(left: 0, top: 30, child: Text(timeLabel)),
              if (visit != null)
                Positioned(
                  left: 60,
                  top: 10,
                  right: 10,
                  child: VisitCard(visit: visit),
                ),
            ],
          ),
        );
      },
    );
  }
}

class VisitCard extends StatelessWidget {
  final VisitingEntity visit;

  const VisitCard({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  visit.visiterID ?? visit.postID ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat.jm().format(visit.dateTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
