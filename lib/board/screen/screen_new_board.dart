import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cspc_recog/urls.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

final List<Color> ColorList = [
  Color(0xff86e3ce),
  Color(0xffd0e6a5),
  Color(0xffffdd94),
  Color(0xfffa897b),
  Color(0xffccabd8),
];

class NewBoardScreen extends StatefulWidget {
  int groupId;
  NewBoardScreen({this.groupId});
  @override
  _NewBoardScreenState createState() => _NewBoardScreenState();
}

class _NewBoardScreenState extends State<NewBoardScreen> {
  final formKey = GlobalKey<FormState>();

  String name = '';

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    _createBoard(int pk) async {
      print(pk.toString());
      var request = http.MultipartRequest(
          'POST', Uri.parse(UrlPrefix.urls + 'board/newboard'));
      request.fields['board_name'] = name;
      request.fields['group_id'] = pk.toString();

      final response = await request.send();
      if (response.statusCode == 201) {
        print("board create complete!");
      } else {
        throw Exception('falied!');
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "새로운 게시판",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: ColorList[3],
        ),
        body: SafeArea(
            child: Center(
                child: Column(children: [
          Form(
            key: this.formKey,
            child: Column(
              children: [
                Container(
                  width: width * 0.9,
                  child: TextFormField(
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '(10자 이내)',
                      labelText: '게시판 이름',
                    ),
                    onSaved: (val) {
                      this.name = val;
                    },
                    validator: (val) {
                      if (val.length < 1) {
                        return '이름이 비어있으면 안됩니다';
                      }
                      if (val.length > 10) {
                        return '10자 이내로 적어주세요';
                      }
                      return null;
                    },
                    //autovalidateMode: AutovalidateMode.always,
                  ),
                ),

                ///게시판 이름
              ],
            ),
          ),
          ButtonTheme(
            minWidth: width * 0.5,
            height: height * 0.05,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ElevatedButton(
              child: Text(
                '게시판 생성',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(Size(width * 0.9, height * 0.05)),
                backgroundColor: MaterialStateProperty.all<Color>(ColorList[3]),
              ),
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  print('form 완료');
                  this.formKey.currentState.save();
                  _createBoard(widget.groupId).whenComplete(() {
                    return Navigator.pop(context);
                  });
                } else {
                  print('nono 안됨');
                }
              },
            ),
          ),
        ]))));
  }
}
