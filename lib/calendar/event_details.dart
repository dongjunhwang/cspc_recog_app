import 'package:flutter/material.dart';
import 'model_event.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../urls.dart';
import 'dart:convert';

class EventDetails extends StatelessWidget {
  final CalendarEvent event;
  const EventDetails({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
              onPressed: () {
                //edit
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () async {
                //delete
                final confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Warning!"),
                              content: Text("Are you sure you want to delete?"),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text("Delete")),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text("Cancel",
                                      style: TextStyle(
                                          color: Colors.grey.shade700)),
                                ),
                              ],
                            )) ??
                    false;
                if (confirm) {
                  //TODO : delete and pop
                  deleteEvent(event.id);
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            title: Text(
              event.title,
              style: Theme.of(context).textTheme.headline5,
            ),
            subtitle: Text(DateFormat("yyyy.MM.dd a hh:mm").format(event.date)),
          ),
          const SizedBox(height: 10.0),
          if (event.description != null)
            ListTile(
              title: Text(event.description),
            ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

Future deleteEvent(int id) async {
  final response = await http.delete(
    Uri.parse(UrlPrefix.urls + 'calendars/1/event/$id/delete/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
  } else {
    throw Exception('Falied to delete Event.');
  }
}
