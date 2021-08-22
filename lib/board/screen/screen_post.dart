import 'package:cspc_recog/board/model/model_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:like_button/like_button.dart';
import 'package:cspc_recog/urls.dart';
import 'package:http/http.dart' as http;
class PostScreen extends StatefulWidget {

  PostList post;
  List<Comment> comments = [];
  List<ImageUrl> images = [];
  int id;
  PostScreen({this.post,this.comments,this.id, this.images});

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
      top:true,
      left:true,
      right:true,
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.deepOrange,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
            mainAxisSize: MainAxisSize.min,
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
              postView(widget.post, width, height),
              commentListView(widget.comments, width, height)
            ],
          ),
        )
        ),
      ),
    );
  }

  Widget postView(PostList post, double width, double height) {
    double buttonSize = 30.0;
    SwiperController _controller = SwiperController();
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
            color: Colors.white
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container( ///제목
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
              Container( ///작성자
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
              Container( ///내용
                width : width*0.8,
                padding: EdgeInsets.all(width * 0.024),
                child: Text(
                  post.contents,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize:width*0.040,
                  ),
                ),
              ),
              (post.hasImage)
              ?Container(
                width: width*0.5,
                height: height*0.5,
                child: Swiper(
                    controller: _controller,
                    loop:true,
                    itemCount:widget.images.length,
                    itemBuilder:(BuildContext context, int index){
                      return imagesView(widget.images[index],width,height);
                    }
                ),
              )
              : Container(
                width: width*0.8,
                height:height*0.1
              )
              ,
              Container( ///좋아요
                width: width * 0.8,
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
              )
            ]
        )
    );
  }
  Future<bool> onLikeButtonTapped(bool isLiked) async{
    /// send your request here
    // final bool success= await sendRequest();
    // 게시글 번호 pk인 게시글의 좋아요 1 증가
    final response = await http.post(
        Uri.parse(UrlPrefix.urls+'board/like/'+widget.id.toString()),
        body: <String,String>{
          'profile': '1', //profile id
        }
    );
    if(response.statusCode == 200) {
      final bool success = true;
    }
    else{
      final bool success = false;
    }
    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  Widget imagesView(ImageUrl image, double width, double height) {
    return Container(
      width: width * 0.3,
      child: Image.network(UrlPrefix.urls + image.imgUrl.substring(1)),
    );
  }

  Widget commentListView(List<Comment> comments, double width, double height){
    return Container(
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                  children:commentCandidates(width, comments)
              )
            ]
        )
    );
  }

  List<Widget> commentCandidates(double width, List<Comment> comments){
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
                      padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, width*0.02),
                      child: Text(
                        comments[i].contents,
                        textAlign: TextAlign.left,
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

  void loadImages(){
    //final response = await http.get(Uri.parse(UrlPrefix.urls+'board/comment/'+pk.toString()));
    

  }

}