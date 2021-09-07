import 'package:cspc_recog/board/model/model_board.dart';
import 'package:cspc_recog/board/screen/screen_edit_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:like_button/like_button.dart';
import 'package:cspc_recog/urls.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/model_board.dart';

final List<Color> ColorList = [
  Color(0xff86e3ce),
  Color(0xffd0e6a5),
  Color(0xffffdd94),
  Color(0xfffa897b),
  Color(0xffccabd8),
];
class PostScreen extends StatefulWidget {
  Post post;
  String boardName;
  int boardId;
  int id;
  PostScreen({this.post,this.id,this.boardName,this.boardId});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final formKey = GlobalKey<FormState>();


  List<Comment> comments = [];
  List<ImageUrl> images = [];

  //임시 profileId, nickName
  int profileId = 1;
  String nickName = "승민";
  String content;



  _sendComment(int pk) async{
    print(pk.toString());
    var request = http.MultipartRequest('POST',Uri.parse(UrlPrefix.urls+'board/comment/'+pk.toString()));
    request.fields['author'] = profileId.toString();
    request.fields['contents']= content;
    request.fields['post_id'] = pk.toString();

    final response = await request.send();
    if(response.statusCode == 201) {
      print("send complete!");
    }
    else{
      throw Exception('falied!');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;
    double width = screenSize.width;
    double height = screenSize.height;
    print("4");
    return SafeArea(
      top:true,
      left:true,
      right:true,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.boardName),
            backgroundColor: ColorList[3],
        ),
        resizeToAvoidBottomInset: true,
        //backgroundColor: Colors.deepOrange,
        body: Column(
          children: [
            Expanded(

              child:SingleChildScrollView(

                child: Center(
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //postView(widget.post, width, height),
                      FutureBuilder(
                          future: getImages(context, widget.id),
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
                              images = snapshot.data;  // 이거!!!! ㅠㅠ
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    postView(widget.post, width, height),
                                  ]);
                            }
                          }),
                      Divider(),
                      FutureBuilder(
                          future: getCommentList(context, widget.id),
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
                              comments = snapshot.data;  // 이거!!!! ㅠㅠ
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    commentListView(comments, width, height)
                                  ]);
                            }
                          }),
                      //commentListView(comments, width, height),

                    ],
                  ),
                )
            ), ),

            commentFormView(width,height),
          ],
        )

      ),
    );
  }

  Widget postView(Post post, double width, double height) {
    double buttonSize = 30.0;
    SwiperController _controller = SwiperController();
    String postTime;
    if(DateTime.now().difference(post.createdTime).inDays < 365) {
      postTime = new DateFormat('MM/dd kk:mm').format(post.createdTime);
    }
    else{
      postTime = new DateFormat('yy/MM/dd').format(post.createdTime);
    }
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children:<Widget>[
                  Container(
                    width : width*0.8,
                    padding: EdgeInsets.fromLTRB(width*0.024, width * 0.012, 0, 0),
                    child: Text(
                      post.title,
                      textAlign: TextAlign.left,
                      maxLines:1,
                      style: TextStyle(
                        fontSize:width*0.058,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),///제목
                  Container(
                    width:width*0.1,
                    child:IconButton(
                      color:Colors.black45,
                        onPressed: ()=>postOption(context),
                        icon: Icon(Icons.more_horiz)),
                  )
                ],
              ),
              Container(
                width : width*0.9,
                padding: EdgeInsets.fromLTRB(width*0.024, width * 0.012, 0, 0),
                child: Text(
                  '작성자:'+post.nickName,
                  textAlign: TextAlign.left,
                  maxLines:2,
                  style: TextStyle(
                    fontSize:width*0.040,
                  ),
                ),
              ),///작성자
              Container(
                width : width*0.9,
                padding: EdgeInsets.fromLTRB(width*0.024, width * 0.012, 0, 0),
                child: Text(
                  //post.createdTime.toString(),
                  postTime,
                  textAlign: TextAlign.left,
                  maxLines:2,
                  style: TextStyle(
                    fontSize:width*0.035,
                  ),
                ),
              ),///게시 날짜
              Container(
                height:height*0.012,
                width : width*0.8,
              ),
              Container(
                width : width*0.9,
                padding: EdgeInsets.all(width * 0.024),
                child: Text(
                  post.contents,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize:width*0.040,
                  ),
                ),
              ),///내용
              //(post.hasImage>1)

              /*(images.length > 1)
                  ? ((images.length == 1)?
              Container(
                width: width*0.9,
                child: Image.network(UrlPrefix.urls + images[0].imgUrl.substring(1)),
              )
                  :Container(
                width:width*0.7,
                child:SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: Row(
                    //mainAxisSize: MainAxisSize.min,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      imageListView(images, width, height),
                    ],
                  ),
                ),
              ))
                  : Container(
                  width: width*0.9,
                  height:height*0.001
              ),*/
              (post.hasImage)
              ? ((images.length == 1)?
                  Container(
                    width: width*0.8,
                    child: Image.network(UrlPrefix.urls + images[0].imgUrl.substring(1)),
                  )
              :Container(
                width: width*0.5,
                height: width*0.5,
                child: Swiper(
                    controller: _controller,
                    loop:false,
                    pagination: SwiperPagination(),
                    itemCount:images.length,
                    itemBuilder:(BuildContext context, int index){
                      return imagesView(images[index],width,height);
                    }
                ),
              ))
              : Container(
                width: width*0.9,
                height:height*0.001
              ),///이미지*/
              Container(
                width: width * 0.9,
                //padding: EdgeInsets.only(left:width * 0.024),
                child: LikeButton(
                  mainAxisAlignment: MainAxisAlignment.center,
                  size: buttonSize,
                  circleColor: CircleColor(
                      start: Color(0xfff551a2), end: Color(0xfffc1e86)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Color(0xfff551a2),
                    dotSecondaryColor: Color(0xfffc1e86),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.pinkAccent : Colors.grey,
                      size: buttonSize*0.8,
                    );
                  },
                  likeCount: post.like,
                  countBuilder: (int count, bool isLiked, String text) {
                    var color = isLiked ? Colors.pinkAccent : Colors.grey;
                    Widget result;
                    if (count == 0) {
                      result = Text(
                        "0",
                        style: TextStyle(color: color),
                      );
                    } else
                      result = Text(
                        text,
                        style: TextStyle(color: color),
                      );
                    return result;
                  },
                  onTap: onLikeButtonTapped,
                ),
              )///좋아요
            ]
        )
    );
  }

  postOption(mContext){
    showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              children: <Widget>[
                (widget.post.authorId != profileId)
                  ? (SimpleDialogOption(
                  child:Text('신고하기', style:TextStyle(color: Colors.black54)),
                  onPressed: reportPost,
                ))
                  :(SimpleDialogOption(
                      child:Text('글 수정하기', style:TextStyle(color: Colors.black54)),
                      onPressed: editPost,
                  )),
                (widget.post.authorId != profileId)
                  ? (Container())
                  :(SimpleDialogOption(
                    child:Text('글 삭제하기', style:TextStyle(color: Colors.black54)),
                    onPressed: deletePost,
                  )) ,
                SimpleDialogOption(
                  child:Text('취소', style:TextStyle(color: Colors.black54)),
                  onPressed: () => Navigator.pop(context),
                ),
              ]
          );
        });
  }

  reportPost(){
    Navigator.pop(context);
  }

  deletePost() async{
    Navigator.pop(context);
    var response = await http.delete(Uri.parse(UrlPrefix.urls+'board/post/'+widget.post.id.toString()));

    if(response.statusCode == 200) {
      print("delete complete!");
      Navigator.pop(context, true);
    }
    else{
      throw Exception('falied!');
    }
  }

  editPost() async{
    Post tmp;
    Navigator.pop(context);
    tmp = await Navigator.push(
        context, MaterialPageRoute(builder: (context) =>
        EditPostScreen(boardId:widget.boardId,boardName: widget.boardName,post:widget.post)));
    if(tmp != null) {
      setState(() {
        widget.post = tmp;
      });
    }
  }

  commentOption(mContext,Comment comment){
    showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              children: <Widget>[
                (comment.authorId != profileId)
                    ? (SimpleDialogOption(
                  child:Text('신고하기', style:TextStyle(color: Colors.black54)),
                  onPressed: reportPost,
                ))
                    :(SimpleDialogOption(
                  child:Text('댓글 삭제하기', style:TextStyle(color: Colors.black54)),
                  onPressed: (){deleteComment(comment.id);},
                )),
                SimpleDialogOption(
                  child:Text('취소', style:TextStyle(color: Colors.black54)),
                  onPressed: () => Navigator.pop(context),
                ),
              ]
          );
        });
  }

  deleteComment(int id) async{
    Navigator.pop(context);
    var response = await http.delete(Uri.parse(UrlPrefix.urls+'board/comment/delete/'+id.toString()));

    if(response.statusCode == 200) {
      print("delete complete!");
      setState(() {
        comments = [];
      });

    }
    else{
      throw Exception('falied!');
    }
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async{
    /// send your request here
    // final bool success= await sendRequest();
    // 게시글 번호 pk인 게시글의 좋아요 1 증가
    final response = await http.post(
        Uri.parse(UrlPrefix.urls+'board/like/'+widget.id.toString()),
        body: <String,String>{
          'profile': profileId.toString(), //profile id
        }
    );
    if(response.statusCode == 200) {
      final bool success = true;

      print(success);
    }
    else{
      final bool success = false;

      print(success);
    }
    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  Widget imageListView(List<ImageUrl> images, double width, double height){
    List<Widget> _children = [];
    for (int i=0;i<images.length;i++){
      if(i!=0)
        _children.add(Container(width:width*0.01));
      _children.add(imagesView(images[i], width, height));

    }

    return Container(
      child:Row(
        children: <Widget>[
          Row(
            children: _children,
          )
        ],
      )
    );
  }

  Widget imagesView(ImageUrl image, double width, double height) {
    return Container(
      width:width*0.3,
      height: width*0.3,
      decoration: BoxDecoration(
      image: DecorationImage(
        image:NetworkImage(UrlPrefix.urls + image.imgUrl.substring(1)),
          fit:BoxFit.cover
        )
      ),

      //Image.network(UrlPrefix.urls + image.imgUrl.substring(1))

    );
  }

  Widget commentListView(List<Comment> comments, double width, double height){
    return Container(
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                  children:commentCandidates(width, height, comments)
              )
            ]
        )
    );
  }

  List<Widget> commentCandidates(double width,double height, List<Comment> comments){
    List<Widget> _children = [];
    String commentTime;

    for(int i=0;i<comments.length;i++){
      if(i!=0){
        _children.add(
          Divider()
        );
      }

      if(DateTime.now().difference(comments[i].createdTime).inDays < 365) {
        commentTime = new DateFormat('MM/dd kk:mm').format(comments[i].createdTime);
      }
      else{
        commentTime = new DateFormat('yy/MM/dd').format(comments[i].createdTime);
      }
      _children.add(
          Container(
              child:  Column(
                  children:<Widget>[
                    Container(
                      width: width*0.9,
                      child:Row(
                        children: [
                          Container(
                            width : width*0.8,
                            padding: EdgeInsets.fromLTRB(width * 0.024, 0, 0, 0),
                            child: Text(
                              comments[i].nickName,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:width*0.034,
                              ),
                            ),
                          ),
                          Container(
                            width:width*0.1,
                            height:height*0.03,
                            child:IconButton(
                                color:Colors.black45,
                                onPressed: (){commentOption(context, comments[i]);},
                                icon: Icon(Icons.more_horiz)),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width : width*0.9,
                      padding: EdgeInsets.fromLTRB(width * 0.024, 0, 0, width*0.02),
                      child: Text(
                        comments[i].contents,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize:width*0.035,
                        ),
                      ),
                    ),
                    Container(
                        width : width*0.9,
                        padding: EdgeInsets.fromLTRB(width * 0.024, 0, 0, width*0.001),
                        child: Text(
                          commentTime,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize:width*0.025,
                          ),
                        )
                    ),
                  ]
              )
          )
      );
    }
    return _children;
  }

  Widget commentFormView(double width, double height){
    //var formController = TextEditingController();
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: ColorList[3].withOpacity(0.2),
          //color: Colors.white
        ),
      child:Row(
        children: [
          Container(
              width:width*0.8,
              padding:EdgeInsets.fromLTRB(width*0.04, 0, 0, 0),
              child: Form(
                  key: this.formKey,
                  child: Column(children: [
                    TextFormField(
                      //controller: formController,
                      decoration: const InputDecoration(
                        //border: OutlineInputBorder(),
                        border: InputBorder.none,
                        hintText: '댓글을 입력하세요',
                      ),
                      onSaved: (val) {
                        this.content = val;
                      },
                      validator: (val) {
                        if (val.length < 1) {
                          return '내용은 비어있으면 안됩니다';
                        }
                        return null;
                      },
                    )///내용
                  ]
                  )
              )
          ),
          ButtonTheme(
            minWidth:width*0.3,
            height:height*0.2,
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child:TextButton(
              child:Text(
                '댓글 등록',
                style:TextStyle(color:ColorList[3],
                    fontSize: width*0.03,
                    fontWeight: FontWeight.bold,
                ),

              ),
              onPressed: () async{
                if(formKey.currentState.validate()){
                  print('form 완료');
                  this.formKey.currentState.save();
                  _sendComment(widget.post.id).whenComplete((){
                    setState(() {
                      comments = [];
                      //formController.clear();
                    });
                  });
                }
                else{
                  print('nono 안됨');
                }
              },
            ),
          ),
        ],
      )
    );

  }

}