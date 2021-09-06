import 'package:flutter/material.dart';
import 'package:cspc_recog/board/screen/screen_post_list.dart';
import 'package:cspc_recog/board/screen/screen_new_board.dart';
import 'package:cspc_recog/board/model/model_board.dart';


final List<Color> ColorList = [
  Color(0xff86e3ce),
  Color(0xffd0e6a5),
  Color(0xffffdd94),
  Color(0xfffa897b),
  Color(0xffccabd8),
];

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
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            //color: profileColorList[0],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [ColorList[2], ColorList[3]],
            ),
          ),
          child:
          Column(
            children: <Widget>[
              Container(height:height*0.1),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async{
                    setState(() {

                    });
                  },
                  child:SingleChildScrollView(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:<Widget>[
                        Padding(padding: EdgeInsets.all(width * 0.024)),
                        Container(
                            width: width*0.95,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.fromLTRB(0, height*0.01, 0, height*0.01),
                            child: Column(
                              children: [
                                Text(
                                  "게시판 목록",
                                  style:TextStyle(
                                    fontSize: width*0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                              ],
                            )
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
                                  minimumSize: MaterialStateProperty.all(Size(width*0.9, height*0.05)),
                                  backgroundColor: MaterialStateProperty.all<Color>(ColorList[3]),
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
              )
            ],
          )

        )


    );
  }

  List<Widget> BoardList(double width, double height){

    List<Widget> children = [];
    for(int i=0;i<boards.length;i++){
      children.add(
        Container(
          padding:EdgeInsets.only(bottom: width*0.003),
          child:Center(
            child:ButtonTheme(
              minWidth: width*0.8,
              height: height*0.05,
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
              child:ElevatedButton(
                child:Text(
                  boards[i].boardName,
                  style:TextStyle(color:Colors.black87),
                ),
                style:ButtonStyle(
                    shape: MaterialStateProperty.resolveWith( (states){
                      return RoundedRectangleBorder( borderRadius: BorderRadius.circular(20));
                    }
                    ),
                  minimumSize: MaterialStateProperty.all(Size(width*0.9, height*0.05)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
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