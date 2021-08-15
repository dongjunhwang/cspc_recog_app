import 'dart:convert';
import 'model_board.dart';


List<PostList> parsePosts(String responseBody){
  //print("what?");
  final parsed = json.decode(responseBody).cast<Map<String,dynamic>>();
  //print("hehe");
  return parsed.map<PostList>((json)=>PostList.fromJson(json)).toList();
}


List<Comment> parseComments(String responseBody){
  //print("what?");
  final parsed = json.decode(responseBody).cast<Map<String,dynamic>>();
  //print("hehe");
  return parsed.map<Comment>((json)=>Comment.fromJson(json)).toList();
}