class SlotEntity {
  SlotEntity({
    required this.time,
    required this.isBooked,
    required this.start,
    required this.end,
  });
  final String time;
  final bool isBooked;
  final DateTime start;
  final DateTime end;
}
