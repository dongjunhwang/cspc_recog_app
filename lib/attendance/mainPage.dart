import 'package:cspc_recog/attendance/models/profile.dart';
import 'package:cspc_recog/common/custom_icons_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:math';
import 'package:circle_list/circle_list.dart';
import '../urls.dart';

final Color colorMain = Color(0xff86E3CE);
final Color colorProfileBox = Color(0x4D86E3CE);
final Color colorSub = Color(0xffFFDD94);
final fontColor = Colors.grey[600];

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  ProfileModel myProfile;
  double height;
  double width;
  String _title = '';
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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: FutureBuilder<List<ProfileModel>>(
            future: getProfileList(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print(_title);
                List<ProfileModel> profileList = snapshot.data;
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: Container(
                    child: Column(
                      children: [
                        rankingLayout(profileList),
                        onlineProfileView(profileList),
                      ],
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

  Widget rankingLayout(final List<ProfileModel> profileList) {
    profileList.sort((b, a) => a.visitTimeSum.compareTo(b.visitTimeSum));
    final ProfileModel winnerProfile = profileList.first;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: SizedBox(
        height: height * 0.2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: width * 0.61,
              height: height * 0.16,
              child: Container(
                decoration: BoxDecoration(
                  color: colorMain,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: rankingContent(winnerProfile),
              ),
            ),
            SizedBox(
              height: height * 0.16,
              width: width * 0.24,
              child: Container(
                decoration: BoxDecoration(
                  color: colorSub,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: woriContent(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget rankingContent(final ProfileModel profile) {
    return Container(
      //alignment: Alignment.center,
      child: SizedBox(
        height: 0.13,
        width: width * 0.56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: width * 0.06)),
                  Text(
                    "이달의\n옹동이",
                    style: TextStyle(
                      height: 1.32,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: width * 0.1)),
                  SizedBox(
                    height: height * 0.1,
                    width: width * 0.28,
                    child: Stack(
                      children: [
                        profileImageView(
                            profile.profileImageUrl, height * 0.09),
                        Positioned(
                          left: height * 0.05,
                          bottom: 0,
                          child: Text(
                            profile.nickName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: height * 0.01)),
            Text(
              "이번 주에 가장 많이 출석한 사람은 누구일까요?",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget woriContent() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: height * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            CustomIcons.wori2,
            color: Colors.white,
            size: width * 0.1,
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.06, top: height * 0.015),
            child: Text(
              "우리",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget profileImageView(final profileImageUrl, double size) {
    return profileImageUrl == null
        ? Container(
            constraints: BoxConstraints(
              maxHeight: size,
              maxWidth: size,
            ),
            child: SizedBox(
              child: Image(
                height: size,
                width: size,
                fit: BoxFit.contain,
                image: AssetImage('assets/images/profile.png'),
              ),
            ),
          )
        : SizedBox(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: size * 0.9,
                maxWidth: size * 0.9,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      UrlPrefix.urls.substring(0, UrlPrefix.urls.length - 1) +
                          profileImageUrl),
                ),
              ),
            ),
          );
  }

  Widget onlineProfileView(final List<ProfileModel> profileList) {
    final onlineProfileList = profileList.where((e) => e.isOnline);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorMain.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SizedBox(
            height: height * 0.5,
            width: width * 0.9,
            child: Center(
              child: CircleList(
                initialAngle: 5,
                origin: Offset(0, 0),
                innerRadius: 0,
                outerRadius: height * 0.25,
                innerCircleRotateWithChildren: false,
                children: [
                  for (ProfileModel profile in onlineProfileList)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorMain,
                          ),
                          alignment: Alignment.center,
                          width: height * 0.1,
                          height: height * 0.1,
                          child: profileImageView(
                              profile.profileImageUrl, height * 0.1),
                        ),
                        Text(
                          profile.nickName,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: height * 0.01,
          bottom: width * 0.01,
          child: IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(
                Icons.replay_circle_filled_sharp,
                color: colorMain,
                size: height * 0.05,
              )),
        )
      ],
    );
  }
}
