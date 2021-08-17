import 'package:cspc_recog/attendance/provider/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TODO : remove user list button (바로 User list를 볼 수 있도록 하기)
class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<UserModel> userlist = [];
  @override
  void initState() {
    super.initState();
    reloadUser();
  }

  void reloadUser() async {
    userlist = await getUserList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 4,
          children: [for (UserModel user in userlist) userView(user)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          reloadUser();
          setState(() {});
        },
        child: Text('reload'),
      ),
    );
  }

  Widget userView(UserModel user) {
    return Container(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.username,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              user.isOnline ? Text("있음") : Text("없음"),
              //Text(user.lastVisitTime.toString())
            ],
          ),
        ),
      ),
    );
  }
}
