import 'dart:convert';
import 'model_board.dart';

List<Board> parseBoardList(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Board>((json) => Board.fromJson(json)).toList();
}

List<Post> parsePostList(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}

List<Comment> parseComments(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Comment>((json) => Comment.fromJson(json)).toList();
}

List<ImageUrl> parseImgs(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ImageUrl>((json) => ImageUrl.fromJson(json)).toList();
}
