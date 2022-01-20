import 'dart:collection';
import 'dart:convert';
import 'package:cspc_recog/board/model/api_adapter.dart';
import 'package:cspc_recog/board/model/model_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cspc_recog/urls.dart';

class BoardProvider extends ChangeNotifier {
  final List<Post> _posts = [];
  bool _hasNext = true;

  get posts => _posts;

  bool get hasNext => _hasNext;

  getReloadedPostList(boardId) async {
    _posts.clear();
    _hasNext = true;
    Map<String, String> queryParameters = {
      'page': "1",
    };
    Uri uri = Uri.parse(UrlPrefix.urls + 'board/' + boardId.toString());
    final finalUri = uri.replace(queryParameters: queryParameters);
    final response = await http.get(finalUri);
    if (response.statusCode == 200) {
      _posts.addAll(parsePostList(utf8.decode(response.bodyBytes)));
      //print("hehe!" + postList.length.toString());
    } else if (response.statusCode == 202) {
      _posts.addAll(parsePostList(utf8.decode(response.bodyBytes)));
      _hasNext = false;

      //print("last!" + postList.length.toString());
    }
    notifyListeners();
  }

  getPostList(boardId, page) async {
    if (hasNext) {
      Map<String, String> queryParameters = {
        'page': page.toString(),
      };
      print("page" + page.toString());

      Uri uri = Uri.parse(UrlPrefix.urls + 'board/' + boardId.toString());
      final finalUri = uri.replace(queryParameters: queryParameters);
      final response = await http.get(finalUri);
      if (response.statusCode == 200) {
        _posts.addAll(parsePostList(utf8.decode(response.bodyBytes)));
        //print("hehe!" + postList.length.toString());
      } else if (response.statusCode == 202) {
        _posts.addAll(parsePostList(utf8.decode(response.bodyBytes)));
        _hasNext = false;

        //print("last!" + postList.length.toString());
      }
      notifyListeners();
    }
  }
}
