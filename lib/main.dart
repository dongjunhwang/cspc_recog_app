import 'package:cspc_recog/attendance/profileDrawer.dart';
import 'package:cspc_recog/auth/auth.dart';
import 'package:cspc_recog/calendar/calendar.dart';
import 'package:cspc_recog/attendance/mainPage.dart';
import 'package:cspc_recog/board/screen/screen_home.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//Main App Run
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
      ],
      title: 'Main App',
      home: LoginPage(),
    );
  }
}

class MyMainPage extends StatefulWidget {
  MyMainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  int _currentIndex = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _children = [AttendancePage(), BoardPage(), Calendar()];
  final List _title = ["Attendance", "Board", "Calendar"];
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_title[_currentIndex]),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(Icons.account_circle_rounded),
              onPressed: () => _scaffoldKey.currentState.openEndDrawer()),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onTap,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Attendance'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Board'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Calendar'),
          )
        ],
      ),
      endDrawer: Drawer(
        child: ProfileDrawerPage(),
      ),
    );
  }
}
