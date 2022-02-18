import 'package:cspc_recog/attendance/models/profile.dart';
import 'package:cspc_recog/attendance/widget/circle_group.dart';
import 'package:cspc_recog/common/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:circle_list/circle_list.dart';
import '../urls.dart';

final Color colorMain = Color(0xff86E3CE);
final Color colorSub = Color(0xffFFDD94);

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  ProfileModel myProfile;
  double height;
  double width;

  @override
  void initState() {
    super.initState();
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
                List<ProfileModel> profileList = snapshot.data;
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: Container(
                    child: Column(
                      children: [
                        topLayout(profileList),
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

  Widget topLayout(final List<ProfileModel> profileList) {
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
    return GestureDetector(
      onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Success"),
                content: Text("Save successfully"),
              )),
      child: Container(
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
    //final onlineProfileList = profileList;
    final onlineProfileList = profileList.where((e) => e.isOnline);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SizedBox(
              height: height * 0.5,
              width: width * 0.9,
              child: CircleGroup(
                outPadding: width * 0.1,
                childPadding: width * 0.06,
                children: onlineProfileList.map((profile) {
                  final ValueNotifier<bool> isClicked =
                      ValueNotifier<bool>(false);

                  return ValueListenableBuilder(
                      valueListenable: isClicked,
                      builder:
                          (BuildContext context, bool value, Widget widget) {
                        return GestureDetector(
                            child: value == false
                                ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: profile.profileImageUrl ==
                                            null
                                        ? AssetImage(
                                            'assets/images/profile.png')
                                        : NetworkImage(UrlPrefix.urls.substring(
                                                0, UrlPrefix.urls.length - 1) +
                                            profile.profileImageUrl),
                                  )
                                : Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Opacity(
                                        opacity: 0.2,
                                        child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage: profile
                                                        .profileImageUrl ==
                                                    null
                                                ? AssetImage(
                                                    'assets/images/profile.png')
                                                : NetworkImage(UrlPrefix.urls
                                                        .substring(
                                                            0,
                                                            UrlPrefix.urls
                                                                    .length -
                                                                1) +
                                                    profile.profileImageUrl)),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          profile.nickName,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            onTap: () {
                              isClicked.value = !isClicked.value;
                              print(isClicked.value);
                            });
                      });
                }).toList(),
              )),
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
