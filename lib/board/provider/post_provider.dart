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

  setReloadedPostList(boardId) async {
    _posts.clear();
    _hasNext = true;
    await _getPostList(boardId, 1);
    notifyListeners();
  }

  addNextPostList(boardId, page) async {
    if (hasNext) {
      await _getPostList(boardId, page);
      notifyListeners();
    }
  }

  _getPostList(boardId, page) async {
    Map<String, String> queryParameters = {
      'page': page.toString(),
    };
    print("page" + page.toString());

    Uri uri = Uri.parse(UrlPrefix.urls + 'board/' + boardId.toString());
    final finalUri = uri.replace(queryParameters: queryParameters);
    final response = await http.get(finalUri);
    if (response.statusCode == 200) {
      _posts.addAll(parsePostList(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 202) {
      _posts.addAll(parsePostList(utf8.decode(response.bodyBytes)));
      _hasNext = false;
    }
  }
}
