import 'package:cspc_recog/board/model/model_board.dart';
import 'package:cspc_recog/board/screen/screen_post.dart';
import 'package:cspc_recog/board/screen/screen_new_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget{
  List<Post> posts;
  int boardId;
  ListScreen({this.posts,this.boardId});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen>{
  bool isLoading = false;
  List<Comment> comments = [];
  List<ImageUrl> images = [];

  @override
  Widget build(BuildContext context){
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.deepOrange,
            body: SingleChildScrollView(
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
            child: Column(
              children:<Widget>[
                Container(height:height*0.1),
                Center(
                  child:Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border : Border.all(color:Colors.deepOrange)
                    ),
                    width: width*0.5,
                    height: height*0.05,
                    child:ButtonTheme(
                      minWidth:width*0.4,
                      height:height*0.05,
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      child:ElevatedButton(
                        child:Text(
                          '글 작성하기',
                          style:TextStyle(color:Colors.deepOrange),
                        ),
                        style:ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          return Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>
                              NewPostScreen(board_id:widget.boardId)));
                        },
                      ),

                    ),

                  ),

                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.posts.length,
                    itemBuilder: (BuildContext context, int index){
                      return Column(
                        children: [
                          buildListView(widget.posts[index],width,height),
                          Container(height:height*0.01),
                        ],
                      );
                    },
                ),
              ]
            )
        )
    ));
  }
  Widget buildListView(Post post, double width, double height){
    return GestureDetector(
      child:Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color:Colors.white),
            color: Colors.white
        ),
        height:height*0.15,
        width: width*0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width : width*0.8,
              padding: EdgeInsets.only(top: width * 0.012),
              child: Text(
                post.title,
                textAlign: TextAlign.left,
                maxLines:2,
                style: TextStyle(
                  fontSize:width*0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width : width*0.8,
              padding: EdgeInsets.only(top: width * 0.012),
              child: Text(
                post.contents,
                textAlign: TextAlign.left,
                maxLines:2,
                style: TextStyle(
                  fontSize:width*0.035,
                ),
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(width:width*0.02),
                Container(
                  padding: EdgeInsets.all(width * 0.012),
                  child: Text(
                    '작성자:'+post.nickName,
                    textAlign: TextAlign.left,
                    maxLines:2,
                    style: TextStyle(
                      fontSize:width*0.03,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  padding: EdgeInsets.all(width * 0.012),
                  child: Text(
                    '좋아요:'+post.like.toString(),
                    textAlign: TextAlign.center,
                    maxLines:2,
                    style: TextStyle(
                      fontSize:width*0.03,
                    ),
                  ),
                ),
                Container(width:width*0.02),
              ],
            ),
          ],
        ),
      ),
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) =>
          PostScreen(post: post,id:post.id))),
    );

  }
}