import 'package:cspc_recog/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../urls.dart';
import 'package:cspc_recog/auth/models/loginUser.dart';

import 'package:flutter/services.dart';
import 'package:cspc_recog/auth/register.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  LoginUser myLogin;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.white70],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            buttonSection(),
          ],
        ),
      ),
    );
  }

  signIn(String id, pass) async {
    final response = await http.post(
      Uri.parse(UrlPrefix.urls + "users/auth/login/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username": id,
        "password": pass,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data != null) {
        myLogin = LoginUser.fromJson(data);

        print(myLogin.user.userId);
        print(myLogin.user.userName);
        print(myLogin.myProfileList);
        print(myLogin.token);

        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MyMainPage()),
                (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  Container buttonSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, ),
      margin: EdgeInsets.only(top: 25.0),
      child: Column(children: <Widget>[
        ElevatedButton(
          child:
          Text(
            "Sign In",
            style: TextStyle(
                color: Colors.white70,
                fontSize: 20
            ),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            primary: Colors.indigoAccent,
            onPrimary: Colors.black,

            minimumSize: Size(MediaQuery.of(context).size.width, 40),
          ),
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            signIn(idController.text, passwordController.text);
          },
        ),

        SizedBox(height: 20.0),
        TextButton(
          child:
          Text(
            "Don't have an account yet? Sign Up",
            style:
            TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
          onPressed: () {
            setState(() {
              _isLoading = true;
            });

            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => RegisterPage()));

          },
        )
      ]
      ),
    );
  }

  final TextEditingController idController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: idController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "ID",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Password",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Login",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 40.0,
              fontWeight: FontWeight.bold)),
    );
  }
}
