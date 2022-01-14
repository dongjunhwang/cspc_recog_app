import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cspc_recog/urls.dart';

class ProfileModel {
  final int profileId;
  final String nickName;
  final bool isOnline;
  final DateTime lastVisitTime;
  final Duration visitTimeSum;
  final String profileImageUrl;
  final String groupName;

  ProfileModel({
    this.profileId,
    this.nickName,
    this.isOnline,
    this.lastVisitTime,
    this.visitTimeSum,
    this.profileImageUrl,
    this.groupName,
  });
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profileId: json['id'],
      nickName: json['nick_name'],
      isOnline: json['is_online'],
      groupName: json['group_id']['group_name'],
      lastVisitTime: DateTime.parse(json['last_visit_time']),
      visitTimeSum: parseDuration(json['visit_time_sum']),
      profileImageUrl: json['profile_image'],
    );
  }
}

Future<List<ProfileModel>> getProfileList(context) async {
  List<ProfileModel> profileList = [];
  try {
    final response = await http.get(
      Uri.parse(UrlPrefix.urls + 'users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      profileList = data
          .map<ProfileModel>((temp) => ProfileModel.fromJson(temp))
          .toList();
    }
  } catch (e) {
    print(e);
  }
  return profileList;
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
    final int seconds = int.parse(part[2].split('.')[0]); // For over limit time
    return Duration(
        days: days, hours: hours, minutes: minutes, seconds: seconds);
  }
}
