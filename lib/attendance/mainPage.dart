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
              List<UserModel> userlist = snapshot.data;
              return Container(
                child: Column(
                  children: [
                    visitTimeRanking(userlist),
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

  String formatDuration(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0");

  Widget visitTimeRanking(List<UserModel> userlist) {
    userlist.sort(
      (a, b) => b.visitTimeSum.compareTo(a.visitTimeSum),
    );
    return Container(
        padding: EdgeInsets.all(10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                for (int i = 0; i < 3; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${i + 1}등 ${userlist[i].username} "),
                      Text("${formatDuration(userlist[i].visitTimeSum)}"),
                    ],
                  )
              ],
            ),
          ),
        ));
  }

  Widget userView(List<UserModel> userlist) {
    // online user sort
    userlist.sort((a, b) => b.isOnline ? 1 : -1);
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
                      Stack(
                        children: [
                          Icon(
                            Icons.account_circle,
                            size: 50,
                            color: profileColorList[
                                Random().nextInt(profileColorList.length)],
                          ),
                          Positioned(
                            right: 3,
                            bottom: 3,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 5,
                            bottom: 5,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    user.isOnline ? Colors.green : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        user.username,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),

                      //Text("${}")
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
