import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import '../urls.dart';
import 'model_event.dart';

class Event {
  final String title;
  Event({this.title});

  String toString() => this.title;
}

class AddEventPage extends StatefulWidget {
  final DateTime selectedDate;
  final CalendarEvent event;

  const AddEventPage({Key key, this.selectedDate, this.event})
      : super(key: key);
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //title: Text('Add Event'),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                //save event
                bool validated = _formKey.currentState.validate();
                if (validated) {
                  _formKey.currentState.save();
                  final data =
                      Map<String, dynamic>.from(_formKey.currentState.value);

                  data['date'] = data['date'].toUtc().toIso8601String();

                  print(data);
                  if (widget.event == null) {
                    final response = await http.post(
                      Uri.parse(UrlPrefix.urls + 'calendars/1/event/post/'),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(
                        [
                          {
                            "title": data['title'],
                            "description": data['description'],
                            "date": data['date']
                          }
                        ],
                      ),
                    );
                  } else {
                    //edit and update
                    int id = widget.event.id;
                    final response = await http.put(
                      Uri.parse(UrlPrefix.urls + 'calendars/1/event/$id/edit/'),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(
                        [
                          {
                            "title": data['title'],
                            "description": data['description'],
                            "date": data['date']
                          }
                        ],
                      ),
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  /* Title Form */
                  FormBuilderTextField(
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    name: 'title',
                    initialValue: widget.event?.title,
                    decoration: InputDecoration(
                        hintText: "Add Title",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: width * 0.03)),
                  ),
                  Divider(),
                  /* Date Form */
                  FormBuilderDateTimePicker(
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    name: 'date',
                    initialValue: widget.event != null
                        ? widget.event.date
                        : widget.selectedDate ?? DateTime.now(),
                    fieldHintText: "Add Date",
                    inputType: InputType.both,
                    format: DateFormat("yyyy.MM.dd a hh:mm"),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.calendar_today_sharp)),
                  ),
                  Divider(),
                  /* Details Form */
                  FormBuilderTextField(
                    name: 'description',
                    initialValue: widget.event?.description,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add Details",
                        prefixIcon: Icon(Icons.short_text)),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
