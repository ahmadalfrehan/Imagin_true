import 'package:imagin_true/domain/entities/Messages.dart';

class MessagesModel extends Messages {
  MessagesModel({
    required super.text,
    required super.reciverID,
    required super.SenderID,
    required super.dateTime,
    required super.isRead,
    required super.Url,
  });

  factory MessagesModel.fromJson(Map<String, dynamic> json) {
    return MessagesModel(
      text: json['text'],
      reciverID: json['reciverID'],
      SenderID: json['SenderID'],
      dateTime: json['dateTime'],
      isRead: json['isRead'],
      Url: json['Url'],
    );
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
