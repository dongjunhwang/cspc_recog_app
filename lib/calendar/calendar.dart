import 'dart:convert';

import 'package:cspc_recog/calendar/model_event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../urls.dart';
import 'cal_adapter.dart';
import 'event.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<CalendarEvent> eventList = [];
  Map<DateTime, List<CalendarEvent>> eventDict =
      Map<DateTime, List<CalendarEvent>>();

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEvent();
  }

  Future _fetchEvent() async {
    final response =
        await http.get(Uri.parse(UrlPrefix.urls + 'calendars/event/1'));
    if (response.statusCode == 200) {
      setState(() {
        eventList = parseEvents(utf8.decode(response.bodyBytes));
      });
      //print(eventList);
      for (CalendarEvent e in eventList) {
        DateTime key = new DateTime(e.date.year, e.date.month, e.date.day);

        if (!eventDict.containsKey(key)) {
          eventDict[key] = [e];
        } else {
          List<CalendarEvent> exsitingValue = eventDict[key];
          exsitingValue.add(e);
        }
      }
      //print(eventDict);
    } else {
      throw Exception('falied!');
    }
  }

  List<CalendarEvent> _getEventsFromDay(DateTime date) {
    DateTime dateChangedFormat = new DateTime(date.year, date.month, date.day);
    return eventDict[dateChangedFormat] ?? [];
  }
  /*Future<List<CalendarEvent>> _getEventsFromDay (
    Map<DateTime, List<CalendarEvent>> eventDict, DateTime date) async{
  DateTime dateChangedFormat = new DateTime(date.year, date.month, date.day);
  List<CalendarEvent> events = eventDict[dateChangedFormat];
  return events;
}*/

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    if (eventDict != null) {
      var getEventsFromDay = _getEventsFromDay(selectedDay);
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    child: TableCalendar(
                      locale: 'ko-KR',
                      firstDay: DateTime(1960),
                      focusedDay: selectedDay,
                      lastDay: DateTime(2100),
                      calendarFormat: format,
                      onFormatChanged: (CalendarFormat _format) {
                        setState(() {
                          format = _format;
                        });
                      },
                      onDaySelected: (DateTime selectDay, DateTime focusDay) {
                        setState(() {
                          selectedDay = selectDay;
                          focusedDay = focusDay;
                        });
                      },
                      eventLoader: _getEventsFromDay,
                      /*Calendar Style*/
                      calendarStyle: CalendarStyle(
                          isTodayHighlighted: true,
                          selectedDecoration: BoxDecoration(
                            color: Colors.blue,
                            /*shape: BoxShape.rectangle,
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(5.0))*/
                          ),
                          selectedTextStyle: TextStyle(color: Colors.white),
                          todayDecoration: BoxDecoration(
                            color: Colors.grey,
                            //shape: BoxShape.rectangle,
                            //borderRadius: BorderRadius.circular(5.0)
                          ),
                          weekendTextStyle: TextStyle(color: Colors.grey)),
                      selectedDayPredicate: (DateTime date) {
                        return isSameDay(selectedDay, date);
                      },
                      /*Calendar Header Style*/
                      headerStyle: HeaderStyle(
                        /* Header Box */
                        //decoration: BoxDecoration(color: Colors.deepPurple),
                        headerMargin: EdgeInsets.only(bottom: height * 0.02),
                        headerPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.05, vertical: height * 0.02),
                        /*title*/
                        //titleCentered: true,
                        /* Format Button */
                        formatButtonVisible: true,
                        formatButtonShowsNext: false,
                        formatButtonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.blue),
                        formatButtonTextStyle: TextStyle(color: Colors.white),
                        /* Calendar arrow */
                        leftChevronVisible: false,
                        rightChevronVisible: false,
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(fontSize: 13),
                          weekendStyle: TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: getEventsFromDay.length,
                  shrinkWrap: true,
                  //physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final event = getEventsFromDay[index];
                    return ListTile(
                      title: Text(event.title),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => Container(),
                      ),
                      subtitle: Text(DateFormat("a hh:mm").format(event.date)),
                    );
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEventPage(
                            selectedDate: selectedDay,
                          )));
            },
            label: Text("Add Event"),
            icon: Icon(Icons.add)),
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
