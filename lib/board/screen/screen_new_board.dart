import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cspc_recog/urls.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class NewBoardScreen extends StatefulWidget{
  int group_id;
  NewBoardScreen({this.group_id});
  @override
  _NewBoardScreenState createState() => _NewBoardScreenState();
}

class _NewBoardScreenState extends State<NewBoardScreen>{
  final formKey = GlobalKey<FormState>();

  String name='';

  @override
  Widget build(BuildContext context){
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    _createBoard(int pk) async{
      print(pk.toString());
      var request = http.MultipartRequest('POST',Uri.parse(UrlPrefix.urls+'board/newboard'));
      request.fields['board_name'] = name;
      request.fields['group_id'] = pk.toString();

      final response = await request.send();
      if(response.statusCode == 201) {
        print("board create complete!");
      }
      else{
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
                            hintText: '게시판 이름을 입력하세요',
                            labelText: '게시판 이름',
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
                          //autovalidateMode: AutovalidateMode.always,
                        ), ///게시판 이름
                        //사진
                      ],
                    ),
                  ),
                  ButtonTheme(
                    minWidth:width*0.5,
                    height:height*0.05,
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child:ElevatedButton(
                      child:Text(
                        '게시판 생성',
                        style:TextStyle(color:Colors.white),
                      ),
                      style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                      ),
                      onPressed: () async{
                        if(formKey.currentState.validate()){
                          print('form 완료');
                          this.formKey.currentState.save();
                          _createBoard(widget.group_id).whenComplete((){
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