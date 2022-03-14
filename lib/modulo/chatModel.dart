class ChatModel {
  String? text;
  String? reciverID;
  String? SenderID;
  String? dateTime;
  ChatModel({
    this.text,
    this.reciverID,
    this.SenderID,
    this.dateTime,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    reciverID = json['reciverID'];
    SenderID = json['SenderID'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'reciverID': reciverID,
      'SenderID': SenderID,
      'dateTime': dateTime,
    };
  }
}
