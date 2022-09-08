class PostModel {
  String? name;
  String? uId;
  String? Image;
  String? PostImage;
  String? text;
  String? dateTime;

  PostModel({
    this.name,
    this.uId,
    this.Image,
    this.PostImage,
    this.dateTime,
    this.text,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    PostImage = json['PostImage'];
    name = json['name'];
    Image = json['Image'];
    uId = json['uId'];
    text = json['text'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'PostImage': PostImage,
      'uId': uId,
      'Image': Image,
      'text': text,
      'dateTime': dateTime,
    };
  }
}
