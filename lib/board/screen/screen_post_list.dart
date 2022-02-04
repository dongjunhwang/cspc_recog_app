import 'package:cspc_recog/board/model/model_board.dart';
import 'package:cspc_recog/board/provider/post_provider.dart';
import 'package:cspc_recog/board/screen/screen_post.dart';
import 'package:cspc_recog/board/screen/screen_new_post.dart';
import 'package:cspc_recog/common/custom_icons_icons.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

final List<Color> ColorList = [
  Color(0xff86e3ce),
  Color(0xffd0e6a5),
  Color(0xffffdd94),
  Color(0xfffa897b),
  Color(0xffccabd8),
];

class ListScreen extends StatefulWidget {
  int boardId;
  String boardName;
  ListScreen({this.boardId, this.boardName});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  BoardProvider boardProvider;
  //List<Post> posts = [];
  //List<Comment> comments = [];
  //List<ImageUrl> images = [];

  ScrollController listController;
  int curPage = 1;

  bool loading = false;
  @override
  void initState() {
    super.initState();
    listController = new ScrollController()..addListener(scrollListener);
    initPostList();
  }

  void initPostList() async {
    boardProvider = Provider.of<BoardProvider>(context, listen: false);
    await boardProvider.setReloadedPostList(widget.boardId);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: width * 0.15,
        leading: IconButton(
          icon: Icon(CustomIcons.before),
          color: Colors.black,
          iconSize: height * 0.025,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Text(
              widget.boardName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Text(
              "CSPC",
              style: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        centerTitle: true,
        /*
        actions: [
          new IconButton(
            icon: Icon(Icons.create),
            onPressed: () async {
              return await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewPostScreen(
                            board_id: widget.boardId,
                            boardName: widget.boardName,
                          ))).then((e) {
                curPage = 1;
              });
            },
          )
        ],
        */
      ),
      //backgroundColor: Colors.deepOrange,
      body: RefreshIndicator(
          onRefresh: () async {
            await boardProvider.setReloadedPostList(widget.boardId);
            curPage = 1;
          },
          child: Scrollbar(
            child: SingleChildScrollView(
                controller: listController,
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(children: <Widget>[
                  Consumer<BoardProvider>(builder: (context, board, _) {
                    final List<Post> posts = board.posts;
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: height * 0.01)),
                          ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: posts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return buildListView(posts[index], width, height);
                            },
                            separatorBuilder: (context, index) {
                              //if (index == 0) return SizedBox.shrink();
                              return const Divider();
                            },
                          ),
                        ]);
                  })
                ])),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          return await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewPostScreen(
                        board_id: widget.boardId,
                        boardName: widget.boardName,
                      ))).then((e) {
            // post_list 돌아올 때 변경된 post reload
            boardProvider.setReloadedPostList(widget.boardId);
            curPage = 1;
          });
        },
        child: const Icon(CustomIcons.pen),
        backgroundColor: ColorList[2],
      ),
    );
  }

  void scrollListener() {
    //print(listController.offset);
    //if(listController.position.extentAfter < 300 && hasNext){
    //if(listController.offset >= listController.position.maxScrollExtent && !listController.position.outOfRange && hasNext){
    if (listController.position.pixels ==
            listController.position.maxScrollExtent &&
        boardProvider.hasNext) {
      //print(curPage);
      boardProvider.addNextPostList(widget.boardId, ++curPage);
    }
  }

  //TODO 진용 UI fix
  Widget buildListView(Post post, double width, double height) {
    String postTime;
    if (DateTime.now().difference(post.createdTime).inMinutes < 60) {
      postTime =
          DateTime.now().difference(post.createdTime).inMinutes.toString() +
              "분 전";
    } else if (DateTime.now().difference(post.createdTime).inHours < 24) {
      postTime = new DateFormat('kk:mm').format(post.createdTime);
    } else if (DateTime.now().difference(post.createdTime).inDays < 365) {
      postTime = new DateFormat('MM/dd').format(post.createdTime);
    } else {
      postTime = new DateFormat('yy/MM/dd').format(post.createdTime);
    }

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),

        height: height * 0.09,
        //width: width*0.9,
        child: Container(
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(30),
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            //color: Colors.grey.shade200
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(children: <Widget>[
                Container(
                  width: width * 0.5,
                  child: Text(
                    post.title,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: height * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                    child: Text(
                  postTime,
                  style: TextStyle(
                    fontSize: width * 0.04,
                  ),
                )),
              ]),
              Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      post.nickName,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: width * 0.03,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    child: Text(
                      '좋아요:' + post.like.toString(),
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: width * 0.03,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostScreen(
                      post: post,
                      id: post.id,
                      boardName: widget.boardName,
                      boardId: widget.boardId,
                    )));
      },
    );
  }
}
