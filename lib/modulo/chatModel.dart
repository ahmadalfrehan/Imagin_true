class ChatModel {
  String? text;
  String? reciverID;
  String? SenderID;
  String? dateTime;
  bool? isRead;
  String? Url;

  ChatModel({
    this.text,
    this.reciverID,
    this.SenderID,
    this.dateTime,
    this.isRead,
    this.Url,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    reciverID = json['reciverID'];
    SenderID = json['SenderID'];
    dateTime = json['dateTime'];
    isRead = json['isRead'];
    Url = json['Url'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'reciverID': reciverID,
      'SenderID': SenderID,
      'dateTime': dateTime,
      'isRead': isRead,
      'Url': Url,
    };
  }
}
