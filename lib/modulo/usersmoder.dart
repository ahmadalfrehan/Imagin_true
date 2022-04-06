class UsersModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? ImageProfile;
  String? Cover;
  String? Bio;
  String? Token;
  String? phoneNumberPrivacy;
  String? emailAddressPrivacy;
  String? BioPrivacy;
  String? profilePicturePrivacy;
  String? coverPicturePrivacy;

  UsersModel({
    this.email,
    this.name,
    this.phone,
    this.uId,
    this.BioPrivacy,
    this.Bio,
    this.Token,
    this.phoneNumberPrivacy,
    this.emailAddressPrivacy,
    this.coverPicturePrivacy,
    this.profilePicturePrivacy,
    this.ImageProfile,
    this.Cover,
  });

  UsersModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    ImageProfile = json['ImageProfile'];
    Cover = json['Cover'];
    Bio = json['Bio'];
    Token = json['Token'];
    phoneNumberPrivacy = json['phoneNumberPrivacy'];
    emailAddressPrivacy = json['emailAddressPrivacy'];
    BioPrivacy = json['BioPrivacy'];
    profilePicturePrivacy = json['profilePicturePrivacy'];
    coverPicturePrivacy = json['coverPicturePrivacy'];
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
