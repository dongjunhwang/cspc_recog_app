import 'package:cspc_recog/board/model/model_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {

  PostList post;
  List<Comment> comments = [];

  PostScreen({this.post,this.comments});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;
    double width = screenSize.width;
    double height = screenSize.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepOrange,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width : width*0.8,
                padding: EdgeInsets.only(top: width * 0.012),
                child: Text(
                  "자세히 보기",
                  textAlign: TextAlign.center,
                  maxLines:2,
                  style: TextStyle(
                    fontSize:width*0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _PostView(widget.post, width, height),
              _CommentListView(widget.comments, width, height)
            ],
          ),
        ),
      ),
    );
  }

  Widget _PostView(PostList post, double width, double height) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
            color: Colors.white
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width : width*0.8,
                padding: EdgeInsets.only(top: width * 0.012),
                child: Text(
                  post.title,
                  textAlign: TextAlign.center,
                  maxLines:2,
                  style: TextStyle(
                    fontSize:width*0.058,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width : width*0.8,
                padding: EdgeInsets.only(top: width * 0.012),
                child: Text(
                  '작성자:'+post.author,
                  textAlign: TextAlign.center,
                  maxLines:2,
                  style: TextStyle(
                    fontSize:width*0.040,
                  ),
                ),
              ),
              Container(
                width : width*0.8,
                padding: EdgeInsets.all(width * 0.024),
                child: Text(
                  post.contents,
                  textAlign: TextAlign.left,
                  maxLines:10,
                  style: TextStyle(
                    fontSize:width*0.040,
                  ),
                ),
              ),
              Container(
                width : width*0.8,
                padding: EdgeInsets.only(top: width * 0.012),
                child: Text(
                  '좋아요:'+post.like.toString(),
                  textAlign: TextAlign.center,
                  maxLines:2,
                  style: TextStyle(
                    fontSize:width*0.035,
                  )
                  ,
                )
                ,
              )
              ,
            ]
        )
    );

  }

  Widget _CommentListView(List<Comment> comments, double width, double height){
    return Container(
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                  children:_commentCandidates(width, comments)
              )
            ]
        )
    );
  }
  List<Widget> _commentCandidates(double width, List<Comment> comments){
    List<Widget> _children = [];
    for(int i=0;i<comments.length;i++){
      print('comment+'+i.toString());
      _children.add(
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.deepOrangeAccent),
                  color: Colors.white
              ),
              child:  Column(
                  children:<Widget>[
                    Container(
                      width : width*0.8,
                      padding: EdgeInsets.fromLTRB(width * 0.05, width*0.02, 0, width*0.001),
                      child: Text(
                        comments[i].author,
                        textAlign: TextAlign.left,
                        maxLines:2,
                        style: TextStyle(
                          fontSize:width*0.025,
                        ),
                      ),
                    ),
                    Container(
                      width : width*0.8,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, width*0.02),
                      child: Text(
                        comments[i].contents,
                        textAlign: TextAlign.center,
                        maxLines:2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:width*0.035,
                        ),
                      ),
                    )
                  ]
              )
          )
      );
    }
    return _children;
  }
}