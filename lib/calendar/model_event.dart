import 'package:intl/intl.dart';

class EventList {
  String clubId;

  EventList({this.clubId});

  EventList.fromMap(Map<String, dynamic> map) : clubId = map['clubId'];
}

class CalendarEvent {
  String title;
  DateTime date;
  String description;

  CalendarEvent({this.title, this.date, this.description});

  CalendarEvent.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    date = DateTime.parse(map['dateString']);
    description = map['description'];
  }

  CalendarEvent.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    date = DateTime.parse(json['date']);
    description = json['description'];
  }

  @override
  String toString() {
    return '{${this.title},${this.date},${this.description}}';
  }
}
