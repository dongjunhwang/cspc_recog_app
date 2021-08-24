class Board{
  String boardName;
  int boardId;
  Board({this.boardId, this.boardName});

  Board.fromJson(Map<String,dynamic> json)
    : boardName = json['board_name'],
      boardId = json['id'];
}

class Post{
  String title;
  int authorId;
  String nickName;
  String contents;
  int id;
  int like;
  bool hasImage;
  Post({this.id,this.title,this.authorId,this.nickName,this.contents,this.like, this.hasImage});

  Post.fromJson(Map<String,dynamic> json)
      : id = json['id'],
        title = json['title'],
        authorId = json['author'],
        nickName = json['nickname'],
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


class Comment{
  int authorId;
  String nickName;
  String contents;
  int postId;
  Comment({this.authorId, this.nickName, this.contents,this.postId});

  Comment.fromJson(Map<String,dynamic> json)
      : authorId = json['author'],
        nickName = json['nickname'],
        contents = json['contents'],
        postId = json['post_id'];
}