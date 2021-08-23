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
  bool hasImage;
  PostList({this.id,this.title,this.author,this.contents,this.like, this.hasImage});

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
        like = json['like_count'],
        hasImage = json['has_image'];
}

class ImageUrl{
  String imgUrl;

  ImageUrl({this.imgUrl});

  ImageUrl.fromJson(Map<String,dynamic> json)
    : imgUrl = json['image'];
}

class Post{
  String title;
  String author;
  String contents;
  int like;
  bool has_image;
  Post({this.title,this.author,this.contents,this.like, this.has_image});

  Post.fromMap(Map<String,dynamic> map)
      : title = map['title'],
        author = map['author'],
        contents = map['contents'],
        like = map['like'];

  Post.fromJson(Map<String,dynamic> json)
      : title = json['title'],
        author = json['author'],
        contents = json['contents'],
        like = json['like_count'],
        has_image = json['has_image'];
}

class Comment{
  String author;
  String contents;
  int postId;
  Comment({this.author, this.contents,this.postId});

  Comment.fromJson(Map<String,dynamic> json)
      : author = json['author'],
        contents = json['contents'],
        postId = json['post_id'];
}