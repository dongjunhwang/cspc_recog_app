import 'package:cspc_recog/attendance/provider/user.dart';
import 'package:cspc_recog/attendance/userlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//TODO : remove user list button (바로 User list를 볼 수 있도록 하기)
class AttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (BuildContext context) => GetUserListProvider(),
                        child: UserListPage(),
                      ),
                    ),
                  );
                },
                child: Text('User List'))
          ],
        ),
      ),
    );
  }
}
