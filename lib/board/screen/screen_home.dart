import 'package:cspc_recog/board/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:cspc_recog/board/screen/screen_post_list.dart';
import 'package:cspc_recog/board/screen/screen_new_board.dart';
import 'package:cspc_recog/board/model/model_board.dart';
import 'package:provider/provider.dart';

class BoardPage extends StatefulWidget {
  //TODO
  //임시 그룹 아이디
  int groupId = 1;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BoardPage> {
  List<Board> boards = [];
  bool isLoading = false;

  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        FutureBuilder(
                            future: getBoardList(context, widget.groupId),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
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
                                return boardList();
                              }
                            }),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(
                          right: width * 0.1, top: height * 0.01),
                      child: GestureDetector(
                        child: Text(
                          '게시판 생성',
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            color: Colors.black,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NewBoardScreen(groupId: 1)));
                          setState(() {
                            boards = [];
                          });
                        },
                      ),
                    ),

                    ///게시판 생성 버튼
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget boardList() {
    return Container(
      child: Column(
        children: [
          for (final Board board in boards)
            Column(
              children: [
                Padding(padding: EdgeInsets.only(bottom: height * 0.025)),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SizedBox(
                      height: height * 0.09,
                      width: width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                            left: 40,
                          )),
                          Text(
                            board.boardName,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => BoardProvider(),
                        child: ListScreen(
                          boardId: board.boardId,
                          boardName: board.boardName,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  Widget buildStep(double width, String title) {
    return Container(
        padding: EdgeInsets.fromLTRB(
            width * 0.048, width * 0.024, width * 0.048, width * 0.024),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.check_box,
              size: width * 0.04,
            ),
            Padding(
              padding: EdgeInsets.only(right: width * 0.024),
            ),
            Text(title),
          ],
        ));
  }
}
