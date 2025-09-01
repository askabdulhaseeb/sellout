import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});
  static String routeName = 'calender';
  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime selectedDate = DateTime(2023, 7, 4);
  String selectedView = 'Day';
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> appointments = <Map<String, dynamic>>[
    <String, dynamic>{
      'title': 'Audi A3 - Aaron Clark',
      'start': const TimeOfDay(hour: 21, minute: 0),
      'end': const TimeOfDay(hour: 22, minute: 0),
    },
    <String, dynamic>{
      'title': 'Audi A3 - Aaron Clark',
      'start': const TimeOfDay(hour: 13, minute: 0),
      'end': const TimeOfDay(hour: 16, minute: 0),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My appointments')),
      body: Column(
        children: <Widget>[
          // Filters row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                // Date picker dropdown
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Text(DateFormat.yMMMMd().format(selectedDate)),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedView,
                  items: <String>['Day', 'Week', 'Month']
                      .map((String e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (String? v) {
                    if (v != null) setState(() => selectedView = v);
                  },
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: <String>['All', 'Upcoming', 'Past']
                      .map((String e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (String? v) {
                    if (v != null) setState(() => selectedFilter = v);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Timeline + Appointments
          Expanded(
            child: ListView.builder(
              itemCount: 24,
              itemBuilder: (BuildContext context, int hour) {
                final String timeLabel =
                    '${hour.toString().padLeft(2, '0')}:00';

                // find appointment at this hour
                final Map<String, dynamic> appt = appointments.firstWhere(
                  (Map<String, dynamic> a) => a['start'].hour == hour,
                  orElse: () => <String, dynamic>{},
                );

                return SizedBox(
                  height: 80,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        top: 30,
                        child: Text(timeLabel),
                      ),
                      if (appt.isNotEmpty)
                        Positioned(
                          left: 60,
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(appt['title'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${appt['start'].format(context)} - ${appt['end'].format(context)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
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
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
