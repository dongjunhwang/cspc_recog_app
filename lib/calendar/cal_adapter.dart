import 'dart:convert';
import 'model_event.dart';

List<CalendarEvent> parseEvents(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<CalendarEvent>((json) => CalendarEvent.fromJson(json))
      .toList();
}
