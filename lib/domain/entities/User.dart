class User {
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
  String? password;

  User({
    required this.email,
    required this.name,
    required this.phone,
    required this.uId,
    required this.BioPrivacy,
    required this.Bio,
    required this.Token,
    required this.phoneNumberPrivacy,
    required this.emailAddressPrivacy,
    required this.coverPicturePrivacy,
    required this.profilePicturePrivacy,
    required this.ImageProfile,
    required this.Cover,
    required this.password,
  });
}
