import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cspc_recog/urls.dart';
import 'package:http/http.dart' as http;


class NewPostScreen extends StatefulWidget{
  int board_id;
  NewPostScreen({this.board_id});
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen>{
  final formKey = GlobalKey<FormState>();

  String title='';
  String name='';
  String content = '';


  @override
  Widget build(BuildContext context){
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    _sendPost(int pk) async{
      //setState((){
      //  isLoading = true;
      //});
      print(pk.toString());
      final response = await http.post(
          Uri.parse(UrlPrefix.urls+'board/'+pk.toString()),
          body: <String,String>{
            'title': title,
            'author': name,
            'contents': content,
            'board_id': pk.toString()
          }
      );
      if(response.statusCode == 200) {
        print("send complete!");
        //setState(() {
          //comments = parseComments(utf8.decode(response.bodyBytes));
          //isLoading = false;
        //});
      }
      else{
        print('nono');
        throw Exception('falied!');
      }
    }

    return Scaffold(
        body:
        SafeArea(
        child: Column(
              children: [
                Form(
                  key: this.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '제목을 입력하세요',
                          labelText: '제목',
                        ),
                        onSaved: (val) {
                          this.title = val;
                        },
                        validator: (val) {
                          if(val.length<1){
                            return '제목은 비어있으면 안됩니다';
                          }
                          return null;
                        },
                        //autovalidateMode: AutovalidateMode.always,
                      ),
                      Container(height: height*0.012),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '이름을 입력하세요',
                          labelText: '이름',
                        ),
                        onSaved: (val) {
                          this.name = val;
                        },
                        validator: (val) {
                          if(val.length<1){
                            return '이름은 비어있으면 안됩니다';
                          }
                          return null;
                        },
                      ),
                      Container(height: height*0.012),
                      Container(
                      child: TextFormField(

                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '내용',
                        ),
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        onSaved: (val) {
                          this.content = val;
                        },
                        validator: (val) {
                          if(val.length<1){
                            return '내용을 작성해주세요';
                          }
                          return null;
                        },
                      )
                      )
                    ],
                  ),
                ),
                ButtonTheme(
                  minWidth:width*0.5,
                  height:height*0.05,
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child:ElevatedButton(
                    child:Text(
                      '글 등록',
                      style:TextStyle(color:Colors.white),
                    ),
                    style:ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                    ),
                    onPressed: () async{
                      if(formKey.currentState.validate()){
                        print('form 완료');
                        this.formKey.currentState.save();
                        _sendPost(widget.board_id).whenComplete((){
                          return Navigator.pop(context);
                        });
                      }
                      else{
                        print('nono 안됨');
                      }
                    },
                  ),
                ),
              ]
            )
        )
    );
  }
}