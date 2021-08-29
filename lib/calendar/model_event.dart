class EventList {
  String groupId;

  EventList({this.groupId});

  EventList.fromMap(Map<String, dynamic> map) : groupId = map['groupId'];
}

class CalendarEvent {
  String title;
  DateTime start_date;
  DateTime end_date;
  String description;
  int id;
  int calendar_id;

  CalendarEvent(
      {this.title,
      this.start_date,
      this.end_date,
      this.description,
      this.id,
      this.calendar_id});

  CalendarEvent.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    start_date = DateTime.parse(json['start_date']);
    end_date = DateTime.parse(json['end_date']);
    description = json['description'];
    id = json['id'];
    calendar_id = json['calendar_id'];
  }

  @override
  String toString() {
    return '{${this.title},${this.start_date},${this.end_date},${this.description},${this.id},${this.calendar_id}}';
  }
}
