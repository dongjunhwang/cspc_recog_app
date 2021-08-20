import 'package:cspc_recog/attendance/provider/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

//TODO : remove user list button (바로 User list를 볼 수 있도록 하기)
class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  void initState() {
    super.initState();
  }

  final List<Color> profileColorList = [
    Colors.amber,
    Colors.blue,
    Colors.teal,
    Colors.lime,
    Colors.brown,
    Colors.deepPurple,
    Colors.cyan,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserModel>>(
          future: getUserList(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final List<UserModel> userlist = snapshot.data;
              return Container(
                child: Column(
                  children: [
                    userCount(userlist),
                    Expanded(
                      child: userView(userlist),
                    ),
                  ],
                ),
              );
            } else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        child: Text('reload'),
      ),
    );
  }

  //TODO 현재 온라인인 유저를 표시
  Widget userCount(final List<UserModel> userlist) {
    int cnt = 0;
    userlist.forEach((element) {
      if (element.isOnline) cnt++;
    });
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(10),
      child: Text(
        "현재 : $cnt명",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  Widget userView(final List<UserModel> userlist) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 3,
        children: [
          for (UserModel user in userlist)
            Container(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 50,
                        color: profileColorList[
                            Random().nextInt(profileColorList.length)],
                      ),
                      Text(
                        user.username,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      user.isOnline
                          ? Text(
                              "있음",
                            )
                          : Text("없음"),
                      //Text(user.lastVisitTime.toString())
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
