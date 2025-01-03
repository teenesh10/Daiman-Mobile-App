class Timeslot {
  final String start;
  final String end;

  Timeslot({required this.start, required this.end});

  static List<Timeslot> getTimeslots() {
    return [
      Timeslot(start: "8:00 AM", end: "8:30 AM"),
      Timeslot(start: "8:30 AM", end: "9:00 AM"),
      Timeslot(start: "9:00 AM", end: "9:30 AM"),
      // Add more timeslots up to 2:00 AM
      Timeslot(start: "1:30 AM", end: "2:00 AM"),
    ];
  }
}
