import 'package:cspc_recog/board/model/model_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:like_button/like_button.dart';
import 'package:cspc_recog/urls.dart';
import 'package:http/http.dart' as http;
class PostScreen extends StatefulWidget {
  Post post;
  List<Comment> comments = [];
  List<ImageUrl> images = [];
  int id;
  PostScreen({this.post,this.comments,this.id, this.images});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final formKey = GlobalKey<FormState>();

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
    return SafeArea(
      top:true,
      left:true,
      right:true,
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.deepOrange,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
            //mainAxisSize: MainAxisSize.min,
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
              commentListView(widget.comments, width, height),
              commentFormView(width,height)
            ],
          ),
        )
        ),
      ),
    );
  }

  Widget postView(Post post, double width, double height) {
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
              ),///제목
              Container(
                width : width*0.8,
                padding: EdgeInsets.only(top: width * 0.012),
                child: Text(
                  '작성자:'+post.nickName,
                  textAlign: TextAlign.center,
                  maxLines:2,
                  style: TextStyle(
                    fontSize:width*0.040,
                  ),
                ),
              ),///작성자
              Container(
                width : width*0.8,
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
              (widget.images.length > 1)
                  ? ((widget.images.length == 1)?
              Container(
                width: width*0.8,
                child: Image.network(UrlPrefix.urls + widget.images[0].imgUrl.substring(1)),
              )
                  :Container(
                width:width*0.7,
                child:SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: Row(
                    //mainAxisSize: MainAxisSize.min,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      imageListView(widget.images, width, height),
                    ],
                  ),
                ),
              ))
                  : Container(
                  width: width*0.8,
                  height:height*0.001
              ),
              (post.hasImage)
              ? ((widget.images.length == 1)?
                  Container(
                    width: width*0.8,
                    child: Image.network(UrlPrefix.urls + widget.images[0].imgUrl.substring(1)),
                  )
              :Container(
                width: width*0.5,
                height: width*0.5,
                child: Swiper(
                    controller: _controller,
                    loop:false,
                    pagination: SwiperPagination(),
                    itemCount:widget.images.length,
                    itemBuilder:(BuildContext context, int index){
                      return imagesView(widget.images[index],width,height);
                    }
                ),
              ))
              : Container(
                width: width*0.8,
                height:height*0.001
              ),///이미지*/
              Container(
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
              )///좋아요
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
          'profile': profileId.toString(), //profile id
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
                  children:commentCandidates(width, comments)
              )
            ]
        )
    );
  }

  List<Widget> commentCandidates(double width, List<Comment> comments){
    List<Widget> _children = [];
    for(int i=0;i<comments.length;i++){
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
                        comments[i].nickName,
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

  Widget commentFormView(double width, double height){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.white),
              color: Colors.white
          ),
          width:width*0.8,
            child: Form(
                key: this.formKey,
                child: Column(children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '내용을 입력하세요',
                      labelText: '내용',
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
          child:ElevatedButton(
            child:Text(
              '댓글 등록',
              style:TextStyle(color:Colors.black,fontSize: width*0.02),

            ),
            style:ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () async{
              if(formKey.currentState.validate()){
                print('form 완료');
                this.formKey.currentState.save();
                _sendComment(widget.post.id).whenComplete((){
                  setState(() {
                    Comment comment=  new Comment();
                    comment.nickName = nickName;
                    comment.contents = content;
                    comment.postId = widget.post.id;
                    widget.comments.add(comment);
                    this.formKey.currentState.reset();
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
    );
  }

}