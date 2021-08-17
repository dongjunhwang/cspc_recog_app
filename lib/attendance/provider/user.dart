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

  UserModel({
    this.userId,
    this.username,
    this.isOnline,
    this.lastVisitTime,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      username: json['nick_name'],
      isOnline: json['is_online'],
      lastVisitTime: DateTime.parse(json['last_visit_time']),
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
