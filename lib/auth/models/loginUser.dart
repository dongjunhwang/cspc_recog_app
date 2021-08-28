import 'package:cspc_recog/attendance/models/profile.dart';

class User {
  String token;
  String userId;
  List<ProfileModel> myProfileList;

  User({
    this.userId,
    this.token,
    this.myProfileList,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      myProfileList: getMyProfileList(json['profile']),
    );
  }
}

List<ProfileModel> getMyProfileList(List<dynamic> json) {
  List<ProfileModel> profileList = [];
  for (Map<String, dynamic> temp in json) {
    profileList.add(ProfileModel.fromJson(temp));
  }
  return profileList;
}
