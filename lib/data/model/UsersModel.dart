import '../../domain/entities/Users.dart';

class UsersModel extends Users {
  UsersModel({
    required super.email,
    required super.name,
    required super.phone,
    required super.uId,
    required super.BioPrivacy,
    required super.Bio,
    required super.Token,
    required super.phoneNumberPrivacy,
    required super.emailAddressPrivacy,
    required super.coverPicturePrivacy,
    required super.profilePicturePrivacy,
    required super.ImageProfile,
    required super.Cover,
    required super.password,
    super.latestMessage,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      uId: json['uId'],
      BioPrivacy: json['BioPrivacy'],
      Bio: json['Bio'],
      Token: json['Token'],
      phoneNumberPrivacy: json['phoneNumberPrivacy'],
      emailAddressPrivacy: json['emailAddressPrivacy'],
      coverPicturePrivacy: json['coverPicturePrivacy'],
      profilePicturePrivacy: json['profilePicturePrivacy'],
      ImageProfile: json['ImageProfile'],
      Cover: json['Cover'],
      password: json['password'],
//      latestMessage: List<MessagesModel>.from(
      //      json["latestMessage"].map(
      //          (x) => MessagesModel.fromJson(x),
      //  ),
//      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'uId': uId,
      'BioPrivacy': BioPrivacy,
      'Bio': Bio,
      'Token': Token,
      'phoneNumberPrivacy': phoneNumberPrivacy,
      'emailAddressPrivacy': emailAddressPrivacy,
      'coverPicturePrivacy': coverPicturePrivacy,
      'profilePicturePrivacy': profilePicturePrivacy,
      'ImageProfile': ImageProfile,
      'Cover': Cover,
      'password': password,
      'latestMessage': latestMessage,
    };
  }
}
