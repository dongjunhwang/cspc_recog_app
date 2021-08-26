import 'package:cspc_recog/attendance/models/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:math';

import '../urls.dart';

//TODO : remove profile list button (바로 profile list를 볼 수 있도록 하기)
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

  final List<Icon> rankingIconList = [
    Icon(
      Foundation.crown,
      color: Colors.amber[400],
    ),
    Icon(
      Foundation.crown,
      color: Colors.grey[400],
    ),
    Icon(
      Foundation.crown,
      color: Colors.brown[400],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // if up swipe, reload
        onVerticalDragUpdate: (dragUpdateDetails) {
          setState(() {});
        },
        child: FutureBuilder<List<ProfileModel>>(
            future: getProfileList(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<ProfileModel> profileList = snapshot.data;
                return Container(
                  child: Column(
                    children: [
                      visitTimeRanking(profileList),
                      profileCount(profileList),
                      Expanded(
                        child: profileView(profileList),
                      ),
                    ],
                  ),
                );
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  //현재 온라인 count
  Widget profileCount(final List<ProfileModel> profileList) {
    int cnt = 0;
    profileList.forEach((element) {
      if (element.isOnline) cnt++;
    });
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(10),
      child: Text(
        "온라인 : $cnt명",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  String formatDuration(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0");

  // 누적 방문시간 랭킹 표시
  Widget visitTimeRanking(List<ProfileModel> profileList) {
    profileList.sort(
      (a, b) => b.visitTimeSum.compareTo(a.visitTimeSum),
    );
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(10),
          child: Text(
            "고인물 랭킹",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.all(10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    for (int i = 0; i < min(3, profileList.length); i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          rankingIconList[i],
                          Text("${profileList[i].nickName} "),
                        ],
                      )
                  ],
                ),
              ),
            )),
      ],
    );
  }

  //프로필 리스트 출력
  Widget profileView(List<ProfileModel> profileList) {
    // online profile sort
    profileList.sort((a, b) => b.isOnline ? 1 : -1);
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: GridView.count(
          crossAxisCount: 4,
          children: [
            for (ProfileModel profile in profileList)
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        profile.profileImageUrl == null
                            ? Icon(
                                Icons.account_circle,
                                size: 50,
                                color: profileColorList[
                                    Random().nextInt(profileColorList.length)],
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(UrlPrefix.urls
                                            .substring(
                                                0, UrlPrefix.urls.length - 1) +
                                        profile.profileImageUrl),
                                  ),
                                ),
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
                                  profile.isOnline ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      profile.nickName,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),

                    //Text("${}")
                    //Text(profile.lastVisitTime.toString())
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
