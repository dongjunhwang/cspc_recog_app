import 'dart:convert';
import 'package:cspc_recog/calendar/event_details.dart';
import 'package:cspc_recog/calendar/model_event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../urls.dart';
import 'cal_adapter.dart';
import 'event.dart';
import 'event_utils.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<CalendarEvent> eventList = [];
  Map<DateTime, List<CalendarEvent>> eventDict =
      Map<DateTime, List<CalendarEvent>>();
  bool load = false;

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future _fetchEvent() async {
    try {
      eventDict = Map<DateTime, List<CalendarEvent>>();
      final response =
          await http.get(Uri.parse(UrlPrefix.urls + 'calendars/1/event'));
      if (response.statusCode == 200) {
        setState(() {
          eventList = parseEvents(utf8.decode(response.bodyBytes));
        });
        //print(eventList);
        for (CalendarEvent e in eventList) {
          DateTime startKey = getOnlyDate(e.start_date);
          DateTime endKey = getOnlyDate(e.end_date);

          for (var key = startKey;
              !key.isAfter(endKey);
              key = key.add(Duration(days: 1))) {
            if (!eventDict.containsKey(key)) {
              eventDict[key] = [e];
            } else {
              List<CalendarEvent> exsitingValue = eventDict[key];
              exsitingValue.add(e);
            }
          }
        }
        load = true;
        //print(eventDict);
      }
    } catch (e) {
      print(e);
    }
  }

  List<CalendarEvent> _getEventsFromDay(DateTime date) {
    DateTime dateChangedFormat = new DateTime(date.year, date.month, date.day);
    return eventDict[dateChangedFormat] ?? [];
  }

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

    if (load) {
      var getEventsFromDay = _getEventsFromDay(selectedDay);
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        decoration: BoxDecoration(color: Colors.blue),
                        headerMargin: EdgeInsets.only(bottom: height * 0.02),
                        headerPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.05, vertical: height * 0.02),
                        /*title*/
                        titleTextStyle: TextStyle(color: Colors.white),
                        //titleCentered: true,
                        /* Format Button */
                        formatButtonVisible: true,
                        formatButtonShowsNext: false,
                        formatButtonDecoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
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
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 8.0),
              child: Text(
                  DateFormat("yyyy.MM.dd EE", 'ko-KR').format(selectedDay),
                  style: Theme.of(context).textTheme.headline6),
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: getEventsFromDay.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final event = getEventsFromDay[index];
                    print(event);
                    String startDateFormat = "MM.dd EE a hh:mm";
                    String endDateFormat = "MM.dd EE a hh:mm";
                    if (getOnlyDate(event.start_date)
                        .isAtSameMomentAs(selectedDay)) {
                      startDateFormat = "a hh:mm";
                    }
                    if (getOnlyDate(event.end_date)
                        .isAtSameMomentAs(selectedDay)) {
                      endDateFormat = "a hh:mm";
                    }
                    String startDateStr = DateFormat(startDateFormat, "ko-kr")
                        .format(event.start_date);
                    String endDateStr = DateFormat(endDateFormat, "ko-kr")
                        .format(event.end_date);
                    return ListTile(
                        title: Text(event.title),
                        subtitle: Text(startDateStr + ' - ' + endDateStr),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetails(
                                      event: event,
                                    ))).then((value) => setState(() {
                              _fetchEvent();
                            })));
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
                          ))).then((value) => setState(() {
                    _fetchEvent();
                  }));
            },
            label: Text("Add Event"),
            icon: Icon(Icons.add)),
      );
    } else {
      _fetchEvent();
      return const Center(child: CircularProgressIndicator());
    }
  }
}
