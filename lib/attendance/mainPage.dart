import 'package:cspc_recog/attendance/models/profile.dart';
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
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 39,
          fontFamily: "Pretendard",
          fontWeight: FontWeight.w500,
        ),
      ),
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
                        rankingLayout(),
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

  Widget rankingLayout() {
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
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget onlineProfileView(List<ProfileModel> profileList) {
    final onlineProfileList = profileList.where((e) => e.isOnline);

    return Container(
        decoration: BoxDecoration(
          color: colorMain.withOpacity(0.3),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: SizedBox(
          height: height * 0.5,
          width: width * 0.9,
          child: Center(
            child: CircleList(
              origin: Offset(0, 0),
              childrenPadding: 10,
              innerRadius: height * 0.05,
              outerRadius: height * 0.2,
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
                        child: profile.profileImageUrl == null
                            ? Icon(
                                //FontAwesome.user_circle_o,
                                MaterialCommunityIcons.account,
                                size: height * 0.1,
                                color: colorSub,
                              )
                            : SizedBox(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: height * 0.09,
                                    maxWidth: height * 0.09,
                                  ),
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
                              ),
                      ),
                      Text(
                        profile.nickName,
                        style: TextStyle(
                          fontSize: 23,
                          fontFamily: "Pretendard",
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      //Text("${}")
                      //Text(profile.lastVisitTime.toString())
                    ],
                  ),
              ],
            ),
          ),
        ));
  }
}
