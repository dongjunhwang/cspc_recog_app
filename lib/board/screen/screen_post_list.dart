import 'package:cspc_recog/board/model/model_board.dart';
import 'package:cspc_recog/board/screen/screen_post.dart';
import 'package:cspc_recog/board/screen/screen_new_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListScreen extends StatefulWidget{
  List<Post> posts;
  int boardId;
  String boardName;
  ListScreen({this.posts,this.boardId,this.boardName});

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
          appBar: AppBar(
            title: Text(widget.boardName),
            actions:[
              new IconButton(
                  icon: Icon(Icons.create),
                  onPressed: () {
                    return Navigator.push(
                        context, MaterialPageRoute(builder: (context) =>
                        NewPostScreen(board_id:widget.boardId)));
                  },)
            ]
          ),
            //backgroundColor: Colors.deepOrange,
            body: SingleChildScrollView(
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
            child: Column(
              children:<Widget>[
                FutureBuilder(
                  future: getPostList(context,widget.boardId),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if (snapshot.hasData == false) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    } else {
                      widget.posts = snapshot.data;  // 이거!!!! ㅠㅠ
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ListView.separated(
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
                            separatorBuilder: (context, index) {
                              //if (index == 0) return SizedBox.shrink();
                              return const Divider();
                            },
                          ),
                        ]
                      );
                    }
                  }
                  ),
              ]
            )
        )
    ));
  }
  Widget buildListView(Post post, double width, double height){
    String postTime;
    if(DateTime.now().difference(post.createdTime).inMinutes < 60){
      postTime = DateTime.now().difference(post.createdTime).inMinutes.toString() + "분 전";
    }
    else if(DateTime.now().difference(post.createdTime).inHours < 24){
      postTime = new DateFormat('kk:mm').format(post.createdTime);
    }
    else if(DateTime.now().difference(post.createdTime).inDays < 365) {
      postTime = new DateFormat('MM/dd').format(post.createdTime);
    }
    else{
      postTime = new DateFormat('yy/MM/dd').format(post.createdTime);
    }

    return GestureDetector(
      child:Container(
        decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(30),
            //border: Border.all(color:Colors.white38),
            color: Colors.grey.shade200
        ),
        height:height*0.15,
        //width: width*0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(width:width*0.02),
                Container(
                  width : width*0.5,
                  padding: EdgeInsets.only(top: width * 0.012),
                  child: Text(
                    post.title,
                    textAlign: TextAlign.left,
                    maxLines:2,
                    style: TextStyle(
                      fontSize:width*0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  child: Text(
                    postTime,
                    style: TextStyle(
                      fontSize:width*0.04,
                    ),
                  )
                ),
                Container(width:width*0.02),
              ]
            ),
            Container(
              width : width*0.8,
              padding: EdgeInsets.only(top: width * 0.012),
              child: Text(
                post.contents,
                textAlign: TextAlign.left,
                maxLines:2,
                style: TextStyle(
                  fontSize:width*0.04,
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
      onTap: ()
         async {
          final del = await Navigator.push(
          context, MaterialPageRoute(builder: (context) =>
          PostScreen(post: post,id:post.id,boardName: widget.boardName,)));
          if(del != null){
            setState(() {
              widget.posts = [];
            });
          }
        }
    );

  }
}