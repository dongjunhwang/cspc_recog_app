import 'dart:convert';
import 'model_board.dart';


List<PostList> parsePosts(String responseBody){
  final parsed = json.decode(responseBody).cast<Map<String,dynamic>>();
  return parsed.map<PostList>((json)=>PostList.fromJson(json)).toList();
}


List<Comment> parseComments(String responseBody){
  final parsed = json.decode(responseBody).cast<Map<String,dynamic>>();
  return parsed.map<Comment>((json)=>Comment.fromJson(json)).toList();
}

List<ImageUrl> parseImgs(String responseBody){
  //print("시작");
  final parsed = json.decode(responseBody).cast<Map<String,dynamic>>();
  //print("사진 끝");
  return parsed.map<ImageUrl>((json)=>ImageUrl.fromJson(json)).toList();
}