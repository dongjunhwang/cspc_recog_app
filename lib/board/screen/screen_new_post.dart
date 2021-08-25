import 'package:cspc_recog/board/model/api_adapter.dart';
import 'package:cspc_recog/board/model/model_board.dart';
import 'package:cspc_recog/board/screen/screen_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cspc_recog/urls.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
class NewPostScreen extends StatefulWidget{
  int board_id;
  NewPostScreen({this.board_id});
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen>{
  final formKey = GlobalKey<FormState>();
  Post createdPost;
  String title='';
  int profile_id = 1; //임시 프로필 아이디
  String name='';
  String content = '';

  final ImagePicker picker = ImagePicker();
  List<XFile> files = [];

  bool isLoading = false;
  List<Comment> comments = [];
  List<ImageUrl> images = [];

  _fetchPost(int postId) async{
    setState((){
      isLoading = true;
    });
    final response = await http.get(Uri.parse(UrlPrefix.urls+'board/post/'+postId.toString()));
    if(response.statusCode == 200) {
      setState(() {
        Map<String,dynamic> postMap = jsonDecode(utf8.decode(response.bodyBytes));
        createdPost = Post.fromJson(postMap);
        isLoading = false;
      });
    }
    else{
      throw Exception('falied!');
    }
  }
  _fetchComments(int pk) async{
    setState((){
      isLoading = true;
    });
    print(pk.toString());
    //final response = await http.get(Uri.parse('https://lsmin1021.pythonanywhere.com/api/post/'+pk.toString()));
    final commentResponse = await http.get(Uri.parse(UrlPrefix.urls+'board/comment/'+pk.toString()));
    if(commentResponse.statusCode == 200) {
      setState(() {
        comments = parseComments(utf8.decode(commentResponse.bodyBytes));
      });
    }
    else{
      throw Exception('falied!');
    }
    print("댓글 완료");
  }
  _fetchImages(int pk) async{
    print("이미지 이쌩");
    final imgResponse = await http.get(
        Uri.parse(UrlPrefix.urls + 'board/image/' + pk.toString()));
    if(imgResponse.statusCode == 200){
      print("불러옴");
      setState(() {
        images = parseImgs(utf8.decode(imgResponse.bodyBytes));
      });
    }
    else{
      throw Exception('Img falied!');
    }
  }


  @override
  Widget build(BuildContext context){
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    _sendPost(int pk) async{
      //print(pk.toString());
      var request = http.MultipartRequest('POST',Uri.parse(UrlPrefix.urls+'board/'+pk.toString()));
      request.fields['title'] = title;
      request.fields['author'] = profile_id.toString();
      request.fields['contents']= content;
      request.fields['board_id'] = pk.toString();
      await Future.forEach(
        files,
          (file) async =>{
            request.files.add(
            http.MultipartFile(
            'image',
            (http.ByteStream(file.openRead())).cast(),
            await file.length(),
            filename:pk.toString()+'.jpg'
            ),
            ),
          }
      );
      final response = await request.send();
      if(response.statusCode == 201) {
        //작성된 글 pk 받아오기
        final postPk = await response.stream.bytesToString();
        print("요기"+int.parse(postPk).toString());
        return int.parse(postPk);
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
                      ), ///제목
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
                      ),///내용
                      Container(
                        child: ButtonTheme(
                          minWidth:width*0.5,
                          height:height*0.05,
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child:ElevatedButton(
                            child:Text(
                              '사진 업로드',
                              style:TextStyle(color:Colors.white),
                            ),
                            style:ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                            ),
                            onPressed: () => takeImage(context)
                          ),
                        ),
                      ), ///사진
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
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        print('form 완료');
                        this.formKey.currentState.save();
                        var postPk = await _sendPost(widget.board_id);
                        print("으아악" + postPk.toString());
                        await _fetchPost(postPk);
                        await _fetchComments(postPk);
                        await _fetchImages(postPk);
                        return Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PostScreen(
                                              post: createdPost,
                                              comments: comments,
                                              id: postPk,
                                              images: images)));
                      }
                      else {
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
  takeImage(mContext){
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            title: Text('이미지 선택',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
            children: <Widget>[
              SimpleDialogOption(
                child:Text('카메라로 찍기', style:TextStyle(color: Colors.black54)),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                  child:Text('갤러리에서 선택', style:TextStyle(color: Colors.black54)),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                  child:Text('취소', style:TextStyle(color: Colors.black54)),
                onPressed: () => Navigator.pop(context),
              ),
            ]
          );
        });
  }

  captureImageWithCamera() async{
    print("카메라");
    Navigator.pop(context);
    XFile imageFile = await picker.pickImage(
        source: ImageSource.camera, maxWidth: 500, maxHeight: 500);
    setState(() {
      this.files.add(imageFile);
    });
  }

  pickImageFromGallery() async{
    print("갤러리");
    Navigator.pop(context);
    List<XFile> imageFiles = await picker.pickMultiImage(maxWidth: 500, maxHeight: 500);
    setState(() {
      this.files = imageFiles;
    });
  }

}