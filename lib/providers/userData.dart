import 'package:cspc_recog/attendance/models/profile.dart';
import 'package:flutter/material.dart';

import 'package:cspc_recog/auth/models/user.dart';

class MyLoginUser with ChangeNotifier {
  User myUser;
  List<ProfileModel> myProfileList;

  MyLoginUser({
    this.myUser,
    this.myProfileList,
  });

  User getUser() => myUser;
  List<ProfileModel> getProfileList() => myProfileList;

  void setUser(User data){
    myUser = data;
    notifyListeners();
  }

  void setProfileList(List<ProfileModel> data){
    myProfileList = data;
    notifyListeners();
  }


}