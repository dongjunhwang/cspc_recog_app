import 'package:cspc_recog/attendance/provider/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserModel>>(
          future: getUserList(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return userView(snapshot.data);
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
      child: Card(
        child: Text(
          "현재 : $cnt",
        ),
      ),
    );
  }

  Widget userView(final List<UserModel> userlist) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 4,
        children: [
          for (UserModel user in userlist)
            Container(
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
            )
        ],
      ),
    );
  }
}
