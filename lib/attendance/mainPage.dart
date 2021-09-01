import 'package:cspc_recog/attendance/models/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:math';

import '../urls.dart';

final List<Color> profileColorList = [
  Color(0xff86e3ce),
  Color(0xffd0e6a5),
  Color(0xffffdd94),
  Color(0xfffa897b),
  Color(0xffccabd8),
];

final fontColor = Colors.grey[600];

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  ProfileModel myProfile;
  @override
  void initState() {
    super.initState();
    myProfile = ProfileModel.fromJson({
      "id": 1,
      "group_id": {"id": 1, "group_name": "cspc", "group_admin_id": 1},
      "nick_name": "jin yong",
      "last_visit_time": "2021-08-25T16:02:59.183817+09:00",
      "visit_time_sum": "1 06:00:00",
      "is_online": true,
      "is_admin": true,
      "profile_image":
          "/media/image/profile/1/image_picker266038817043360961.jpg",
      "user_id": 1
    });
  }

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
      body: Container(
        decoration: BoxDecoration(
          //color: profileColorList[0],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [profileColorList[0], profileColorList[1]],
          ),
          image: DecorationImage(
              image: AssetImage("assets/images/4853433.jpg"),
              fit: BoxFit.cover,
              scale: 0.5,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.dstATop)),
        ),
        child: FutureBuilder<List<ProfileModel>>(
            future: getProfileList(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<ProfileModel> profileList = snapshot.data;
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          groupLogo(),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10.0),
                                  topRight: const Radius.circular(10.0),
                                )),
                            child: Column(
                              children: [
                                profileCount(profileList),
                                profileView(profileList),
                                visitTimeRanking(profileList),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
          color: profileColorList[1],
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget groupLogo() {
    return Container(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 50),
              child: Text(
                "${myProfile.groupName}",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 8,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Hi, ${myProfile.nickName}",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              color: profileColorList[0],
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.topLeft,
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                      color: profileColorList[0].withOpacity(0.7), width: 4)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  children: [
                    for (int i = 0; i < min(3, profileList.length); i++)
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            rankingIconList[i],
                            Text(
                              "${profileList[i].nickName} ",
                              style: TextStyle(
                                color: fontColor,
                              ),
                            ),
                          ],
                        ),
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
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              color: profileColorList[1],
              width: 4,
            )),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: GridView.count(
            crossAxisCount: 4,

            padding: EdgeInsets.all(10),
            //shrinkWrap: true,
            children: [
              for (ProfileModel profile in profileList)
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          profile.profileImageUrl == null
                              ? Icon(
                                  //FontAwesome.user_circle_o,
                                  MaterialCommunityIcons.account,

                                  size: 50,
                                  color: profileColorList[Random()
                                      .nextInt(profileColorList.length)],
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(UrlPrefix.urls
                                              .substring(0,
                                                  UrlPrefix.urls.length - 1) +
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
                                color: profile.isOnline
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        profile.nickName,
                        style: TextStyle(
                          fontSize: 15,
                          color: fontColor,
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
      ),
    );
  }
}
