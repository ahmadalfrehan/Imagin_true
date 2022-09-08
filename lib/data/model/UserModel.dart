import '../../domain/entities/User.dart';

class UserModel extends User {
  UserModel({
    required super.name,
    required super.phone,
    required super.uId,
    required super.Bio,
    required super.email,
    required super.coverPicturePrivacy,
    required super.BioPrivacy,
    required super.emailAddressPrivacy,
    required super.Cover,
    required super.phoneNumberPrivacy,
    required super.profilePicturePrivacy,
    required super.Token,
    required super.ImageProfile,
    required super.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      phone: json['phone'],
      uId: json['uId'],
      Bio: json['Bio'],
      email: json['email'],
      coverPicturePrivacy: json['coverPicturePrivacy'],
      BioPrivacy: json['BioPrivacy'],
      emailAddressPrivacy: json['emailAddressPrivacy'],
      Cover: json['Cover'],
      phoneNumberPrivacy: json['phoneNumberPrivacy'],
      profilePicturePrivacy: json['profilePicturePrivacy'],
      Token: json['Token'],
      ImageProfile: json['ImageProfile'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'uId': uId,
      'ImageProfile': ImageProfile,
      'Cover': Cover,
      'Bio': Bio,
      'Token': Token,
      'phoneNumberPrivacy': phoneNumberPrivacy,
      'emailAddressPrivacy': emailAddressPrivacy,
      'BioPrivacy': BioPrivacy,
      'profilePicturePrivacy': profilePicturePrivacy,
      'coverPicturePrivacy': coverPicturePrivacy,
    };
  }
}
