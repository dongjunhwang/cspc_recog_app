import 'package:cspc_recog/attendance/models/profile.dart';
import 'package:cspc_recog/auth/models/user.dart';

class LoginUser {
  User user;
  String token;
  List<ProfileModel> myProfileList;

  LoginUser({
    this.user,
    this.token,
    this.myProfileList,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      user: User.fromJson(json['user']),
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
