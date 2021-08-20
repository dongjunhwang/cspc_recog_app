import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cspc_recog/urls.dart';

class GetUserListProvider extends ChangeNotifier {
  List<UserModel> userList = [];
  bool loading = false;

  getUserData(context) async {
    loading = true;
    userList = await getUserList(context);
    loading = false;
    notifyListeners();
  }
}

class UserModel {
  final int userId;
  final String username;
  final bool isOnline;
  final DateTime lastVisitTime;
  final Duration visitTimeSum;

  UserModel({
    this.userId,
    this.username,
    this.isOnline,
    this.lastVisitTime,
    this.visitTimeSum,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      username: json['nick_name'],
      isOnline: json['is_online'],
      lastVisitTime: DateTime.parse(json['last_visit_time']),
      visitTimeSum: parseDuration(json['visit_time_sum']),
    );
  }
}

Future<List<UserModel>> getUserList(context) async {
  List<UserModel> userList = [];
  try {
    final response = await http.get(
      Uri.parse(UrlPrefix.urls + "users/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));

      for (Map<String, dynamic> temp in data) {
        userList.add(UserModel.fromJson(temp));
      }
    }
  } catch (e) {
    print(e);
  }
  return userList;
}

Duration parseDuration(String s) {
  final List<String> parts = s.split(' ');

  if (parts.length == 1) {
    final List<String> part = parts[0].split(':');
    final int hours = int.parse(part[0]);
    final int minutes = int.parse(part[1]);
    final int seconds = int.parse(part[2]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  } else {
    final List<String> part = parts[1].split(':');
    final int days = int.parse(parts[0]);
    final int hours = int.parse(part[0]);
    final int minutes = int.parse(part[1]);
    final int seconds = int.parse(part[2]);
    return Duration(
        days: days, hours: hours, minutes: minutes, seconds: seconds);
  }
}
