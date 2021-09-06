import 'package:cspc_recog/attendance/models/profile.dart';
import 'package:cspc_recog/auth/models/user.dart';

class TokenReceiver {
  //User user;
  String token;
  //List<ProfileModel> myProfileList;

  TokenReceiver({
    //this.user,
    this.token,
    //this.myProfileList,
  });

  factory TokenReceiver.fromJson(Map<String, dynamic> json) {
    return TokenReceiver(
      //user: User.fromJson(json['user']),
      token: json['token'],
      //myProfileList: getMyProfileList(json['profile']),
    );
  }
}

/*
List<ProfileModel> getMyProfileList(List<dynamic> json) {
  List<ProfileModel> profileList = [];
  for (Map<String, dynamic> temp in json) {
    profileList.add(ProfileModel.fromJson(temp));
  }
  return profileList;
}
*/
