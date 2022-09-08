import 'package:imagin_true/domain/entities/Response.dart';

class ResponseFromModel extends ResponseFrom {
  ResponseFromModel({
    required super.token,
    required super.uId,
    super.creationTime,
  });

  factory ResponseFromModel.fromJson(Map<String, dynamic> json) {
    return ResponseFromModel(
      token: json['token'],
      uId: json['uId'],
      creationTime: json['creationTime'],
    );
  }
}
