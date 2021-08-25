class EventList {
  String groupId;

  EventList({this.groupId});

  EventList.fromMap(Map<String, dynamic> map) : groupId = map['groupId'];
}

class CalendarEvent {
  String title;
  DateTime date;
  String description;
  int id;

  CalendarEvent({this.title, this.date, this.description, this.id});

  CalendarEvent.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    date = DateTime.parse(map['dateString']);
    description = map['description'];
    id = map['id'];
  }

  CalendarEvent.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    date = DateTime.parse(json['date']);
    description = json['description'];
    id = json['id'];
  }

  @override
  String toString() {
    return '{${this.title},${this.date},${this.description},${this.id}}';
  }
}
