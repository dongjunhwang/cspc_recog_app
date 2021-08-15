import 'package:cspc_recog/attendance/provider/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
    final userlist = Provider.of<GetUserListProvider>(context, listen: false);
    userlist.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    final userlist = Provider.of<GetUserListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("user list"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: userlist.loading
            ? Container(
          child: CircularProgressIndicator(),
        )
            : GridView.count(
          crossAxisCount: 4,
          children: [
            for (UserModel user in userlist.userList) userView(user)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => userlist.getUserData(context),
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
              Text(user.username),
              Text("online : " + user.isOnline.toString()),
              //Text(user.lastVisitTime.toString())
            ],
          ),
        ),
      ),
    );
  }
}