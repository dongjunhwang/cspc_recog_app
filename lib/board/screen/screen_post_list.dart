import 'dart:convert';

import 'package:cspc_recog/board/model/api_adapter.dart';
import 'package:cspc_recog/board/model/model_board.dart';
import 'package:cspc_recog/board/screen/screen_post.dart';
import 'package:cspc_recog/board/screen/screen_new_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import '../../urls.dart';

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
  bool isLoading = false;

  List<Post> posts = [];
  List<Comment> comments = [];
  List<ImageUrl> images = [];

  ScrollController listController;
  int curPage = 1;

  bool loading = false;
  bool hasNext = true;
  @override
  void initState() {
    super.initState();
    listController = new ScrollController()..addListener(scrollListener);
  }

  Future<List<Post>> getPostList(context, boardId, page) async {
    List<Post> postList = [];
    Map<String, String> queryParameters = {
      'page': page.toString(),
    };
    print("page" + page.toString());

    Uri uri = Uri.parse(UrlPrefix.urls + 'board/' + boardId.toString());
    final finalUri = uri.replace(queryParameters: queryParameters);
    final response = await http.get(finalUri);
    if (response.statusCode == 200) {
      postList = parsePostList(utf8.decode(response.bodyBytes));
      print("hehe!" + postList.length.toString());
    } else if (response.statusCode == 202) {
      postList = parsePostList(utf8.decode(response.bodyBytes));
      hasNext = false;

      print("last!" + postList.length.toString());
    }
    return postList;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: Text(widget.boardName),
          backgroundColor: ColorList[3],
          actions: [
            new IconButton(
              icon: Icon(Icons.create),
              onPressed: () {
                return Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewPostScreen(
                              board_id: widget.boardId,
                              boardName: widget.boardName,
                            ))).then((e) async {
                  setState(() {});
                });
              },
            )
          ]),
      //backgroundColor: Colors.deepOrange,
      body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              curPage = 1;
              posts = [];
            });
          },
          child: SingleChildScrollView(
              controller: listController,
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(children: <Widget>[
                FutureBuilder(
                    future: getPostList(context, widget.boardId, curPage),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return CircularProgressIndicator();
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(fontSize: 15),
                              ),
                            );
                          } else {
                            print("wowo" + posts.length.toString());
                            print("sn" + snapshot.data.length.toString());

                            //posts..addAll(snapshot.data);
                            print("end" + posts.length.toString());
                            print("------");
                            if (snapshot.data.length == 0) hasNext = false;
                            posts = snapshot.data;
                            loading = true; // 이거!!!! ㅠㅠ
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: posts.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          buildListView(
                                              posts[index], width, height),
                                          Container(height: height * 0.01),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      //if (index == 0) return SizedBox.shrink();
                                      return const Divider();
                                    },
                                  ),
                                ]);
                          }
                          break;

                        default:
                          return CircularProgressIndicator();
                      }
                    }),
              ]))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          listController.animateTo(0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        },
        child: const Icon(Icons.navigation_sharp),
        backgroundColor: ColorList[2],
      ),
    ));
  }

  void scrollListener() {
    //print(listController.offset);
    //if(listController.position.extentAfter < 300 && hasNext){
    //if(listController.offset >= listController.position.maxScrollExtent && !listController.position.outOfRange && hasNext){
    if (listController.position.pixels ==
            listController.position.maxScrollExtent &&
        hasNext) {
      //print(curPage);
      loading = false;
      setState(() {
        curPage += 1;
      });
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
          decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(30),
              //border: Border.all(color:Colors.white38),
              //color: Colors.grey.shade200
              ),
          height: height * 0.14,
          //width: width*0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: height * 0.005),
              Row(children: <Widget>[
                Container(width: width * 0.03),
                Container(
                  width: width * 0.5,
                  padding: EdgeInsets.only(top: width * 0.012),
                  child: Text(
                    post.title,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: width * 0.05,
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
                Container(width: width * 0.02),
              ]),
              Container(
                width: width * 0.9,
                height: height * 0.04,
                padding: EdgeInsets.only(top: width * 0.012),
                child: Text(
                  post.contents,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: width * 0.04,
                  ),
                ),
              ),
              Expanded(child: Container()),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(width: width * 0.02),
                  Container(
                    padding: EdgeInsets.all(width * 0.012),
                    child: Text(
                      '작성자:' + post.nickName,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: width * 0.03,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    padding: EdgeInsets.all(width * 0.012),
                    child: Text(
                      '좋아요:' + post.like.toString(),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: width * 0.03,
                      ),
                    ),
                  ),
                  Container(width: width * 0.02),
                ],
              ),
            ],
          ),
        ),
        onTap: () async {
          final del = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostScreen(
                        post: post,
                        id: post.id,
                        boardName: widget.boardName,
                        boardId: widget.boardId,
                      )));
          if (del != null) {
            setState(() {
              posts = [];
            });
          }
        });
  }
}
