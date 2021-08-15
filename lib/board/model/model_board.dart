class NoticeBoard{
  String title;
  List<String> candidates;
}
class PostList{
  String title;
  String author;
  String contents;
  int id;
  int like;
  PostList({this.id,this.title,this.author,this.contents,this.like});

  PostList.fromMap(Map<String,dynamic> map)
      : id = map['id'],
        title = map['title'],
        author = map['author'],
        contents = map['contents'],
        like = map['like'];

  PostList.fromJson(Map<String,dynamic> json)
      : id = json['id'],
        title = json['title'],
        author = json['author'],
        contents = json['contents'],
        like = json['like_count'];

}

class Post{
  String title;
  String author;
  String contents;
  int like;
  Post({this.title,this.author,this.contents,this.like});

  Post.fromMap(Map<String,dynamic> map)
      : title = map['title'],
        author = map['author'],
        contents = map['contents'],
        like = map['like'];

  Post.fromJson(Map<String,dynamic> json)
      : title = json['title'],
        author = json['author'],
        contents = json['contents'],
        like = json['like_count'];
}

class Comment{
  String author;
  String contents;
  Comment({this.author, this.contents});

  Comment.fromJson(Map<String,dynamic> json)
      : author = json['author'],
        contents = json['contents'];
}