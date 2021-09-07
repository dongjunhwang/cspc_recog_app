import 'package:cspc_recog/board/model/model_board.dart';
import 'package:cspc_recog/board/screen/screen_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cspc_recog/urls.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
class EditPostScreen extends StatefulWidget{
  Post post;
  int boardId;
  String boardName;
  EditPostScreen({this.post,this.boardId,this.boardName});
  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen>{
  final formKey = GlobalKey<FormState>();
  Post editedPost;
  String title='';
  int profileId = 1; //임시 프로필 아이디
  String name='';
  String content = '';

  final ImagePicker picker = ImagePicker();
  List<XFile> files = [];

  bool isLoading = false;
  List<Comment> comments = [];
  List<ImageUrl> images = [];

  @override
  Widget build(BuildContext context){
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    _editPost() async{
      var request = http.MultipartRequest('PUT',Uri.parse(UrlPrefix.urls+'board/post/'+widget.post.id.toString()));
      request.fields['title'] = title;
      request.fields['author'] = profileId.toString();
      request.fields['contents']= content;
      request.fields['board_id'] = widget.boardId.toString();
      await Future.forEach(
        files,
          (file) async =>{
            request.files.add(
            http.MultipartFile(
            'image',
            (http.ByteStream(file.openRead())).cast(),
            await file.length(),
            filename:widget.boardId.toString()+'.jpg'
            ),
            ),
          }
      );
      final response = await request.send();
      if(response.statusCode == 200) {
        return;
      }
      else{
        throw Exception('falied!');
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "글 수정",
            style: TextStyle(color:Colors.white),
          ),
          backgroundColor: ColorList[3],
        ),
        body:
        SafeArea(
        child: Column(
              children: [
                Container(height:height*0.01),
                Form(
                  key: this.formKey,
                  child: Column(
                    children: [
                      Container(
                        width: width*0.96,
                        decoration: BoxDecoration(
                          //color: Colors.black.withOpacity(0.7),
                          border:Border.all(color:Colors.black54),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child:
                          Container(
                            //width: width*0.7,
                            padding: EdgeInsets.fromLTRB(width*0.024, 0, 0, 0),
                            child: TextFormField(
                              initialValue: widget.post.title,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '제목',
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
                          ),
                      ),
                      Container(height: height*0.012),
                      Container(
                        width: width*0.96,
                        decoration: BoxDecoration(
                          //color: Colors.black.withOpacity(0.7),
                          border:Border.all(color:Colors.black54),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                            padding: EdgeInsets.fromLTRB(width*0.024, 0, 0, 0),
                          child:TextFormField(
                            initialValue: widget.post.contents,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '내용',
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
                          )///내용
                        ),
                      ),
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
                              minimumSize: MaterialStateProperty.all(Size(width*0.9, height*0.05)),
                              backgroundColor: MaterialStateProperty.all<Color>(ColorList[3]),
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
                      minimumSize: MaterialStateProperty.all(Size(width*0.9, height*0.05)),
                      backgroundColor: MaterialStateProperty.all<Color>(ColorList[3]),
                    ),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        print('form 완료');
                        this.formKey.currentState.save();
                        await _editPost();
                        print("1");
                        editedPost = await getPost(context, widget.post.id);
                        Navigator.pop(context,editedPost);
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