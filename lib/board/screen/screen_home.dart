import 'package:flutter/material.dart';
import 'package:cspc_recog/board/screen/screen_post_list.dart';
import 'package:cspc_recog/board/screen/screen_new_board.dart';
import 'package:cspc_recog/board/model/model_board.dart';


class BoardPage extends StatefulWidget{
  //임시 그룹 아이디
  int groupId= 1;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<BoardPage>{
  List<Post> posts = [];
  List<Board> boards = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context){
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return SafeArea(
      child: Scaffold(
        body:SingleChildScrollView(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
              Center(child:
                Text(
                  '게시판 목록',
                  //textScaleFactor: width * 0.01,
                  style:TextStyle(
                    fontSize:width*0.065,
                    fontWeight: FontWeight.bold,
                  )
                )
              ),
              Padding(padding: EdgeInsets.all(width * 0.024)),
              FutureBuilder(
                future: getBoardList(context,widget.groupId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                    boards = snapshot.data;
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(children: BoardList(width, height))
                        ]);
                  }
                }
              ),
              Container(
                padding:EdgeInsets.only(bottom: width*0.036),
                child:Center(
                  child:ButtonTheme(
                    minWidth: width*0.8,
                    height: height*0.05,
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                    child:ElevatedButton(
                      child:Text(
                        '게시판 생성',
                        style:TextStyle(color:Colors.white),
                      ),
                      style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                      ),
                      onPressed: () async {
                          await Navigator.push(context,MaterialPageRoute(builder: (context)=>NewBoardScreen(groupId:1)));
                          setState(() {
                            boards = [];
                          });
                      },
                    ),
                  ),
                ),
              ),///게시판 생성 버튼
            ],
          ),
        ),
      )
    );
  }

  List<Widget> BoardList(double width, double height){

    List<Widget> children = [];
    for(int i=0;i<boards.length;i++){
      children.add(
        Container(
          padding:EdgeInsets.only(bottom: width*0.036),
          child:Center(
            child:ButtonTheme(
              minWidth: width*0.8,
              height: height*0.05,
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
              child:ElevatedButton(
                child:Text(
                  boards[i].boardName,
                  style:TextStyle(color:Colors.white),
                ),
                style:ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                ),
                onPressed: () {
                  /*ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:Row(
                          children: [
                            CircularProgressIndicator(),
                            Padding(
                              padding: EdgeInsets.only(left:width * 0.036),
                            ),
                            Text("Loading..."),
                          ],
                        ),
                        duration: Duration(seconds:10),
                      )
                  );*/
                  //_fetchPosts(boards[i].boardId).whenComplete((){
                    //ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    return Navigator.push(context,MaterialPageRoute(builder: (context)=>ListScreen(posts:posts,boardId:boards[i].boardId,boardName: boards[i].boardName,)));
                  //});
                },
              ),
            ),
          ),
        )
      );
    }
    return children;
  }
  Widget buildStep(double width, String title){
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