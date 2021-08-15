import 'package:cspc_recog/board/model/api_adapter.dart';
import 'package:flutter/material.dart';
import 'package:cspc_recog/board/screen/screen_post_list.dart';
import 'package:cspc_recog/board/model/model_board.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cspc_recog/board/model/api_adapter.dart';


class BoardPage extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<BoardPage>{
  final GlobalKey<ScaffoldState> _scaffoladKey = GlobalKey<ScaffoldState>();

  List<PostList> posts = [];
  bool isLoading = false;

  _fetchPosts() async{
    setState((){
      isLoading = true;
    });
    final response = await http.get(Uri.parse('https://lsmin1021.pythonanywhere.com/api/post/'));
    if(response.statusCode == 200) {
      setState(() {
        posts = parsePosts(utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    }
    else{
      throw Exception('falied!');
    }
  }
  /*List<Post> posts = [
    Post.fromMap({'title':'test','author':'me','contents':'하하하','like':10}),
    Post.fromMap({'title':'test','author':'you','contents':'하하하1','like':0}),
    Post.fromMap({'title':'test','author':'us','contents':'하하하2','like':2}),
  ];*/

  @override
  Widget build(BuildContext context){
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoladKey,
        /*
        appBar:AppBar(
          title:Text('Board App'),
          backgroundColor: Colors.deepOrange,
          leading: Container(),
        ),
        */

        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:<Widget>[
            Center(child:Text('게시판',textScaleFactor: width * 0.01,)),
            Padding(padding: EdgeInsets.all(width * 0.024)),
            Text(
                '프로토타입',
                style:TextStyle(
                  fontSize:width*0.065,
                  fontWeight: FontWeight.bold,
                )
            ),
            Padding(padding:EdgeInsets.all(width*0.024)),
            _buildStep(width, '아직 게시판 분리 못함'),
            _buildStep(width, '게시글 및 댓글 불러오기 가능!'),
            Padding(padding:EdgeInsets.all(width*0.024)),
            Container(
              padding:EdgeInsets.only(bottom: width*0.036),
              child:Center(
                child:ButtonTheme(
                  minWidth: width*0.8,
                  height: height*0.05,
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                  child:ElevatedButton(
                    child:Text(
                      '게시판 입장',
                      style:TextStyle(color:Colors.white),
                    ),
                    style:ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:Row(
                                children: [
                                  CircularProgressIndicator(),
                                  Padding(
                                    padding: EdgeInsets.only(left:width * 0.036),
                                  ),
                                  Text("Loading..."),
                                ],
                              )
                          )
                      );
                      _fetchPosts().whenComplete((){
                        return Navigator.push(context,MaterialPageRoute(builder: (context)=>ListScreen(posts:posts,)));
                      });

                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(double width, String title){
    return Container(
        padding:EdgeInsets.fromLTRB(
            width * 0.048,
            width*0.024,
            width*0.048,
            width*0.024
        ),
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Icon(Icons.check_box,
              size:width * 0.04,
            ),
            Padding(padding: EdgeInsets.only(right:width*0.024),),
            Text(title),
          ],
        )
    );
  }
}