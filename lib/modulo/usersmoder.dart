class UsersModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? ImageProfile;
  String? Cover;
  String? Bio;
  String? Token;
  bool? isEmailVerifaed;

  UsersModel(
      {this.email,
      this.name,
      this.phone,
      this.uId,
      this.isEmailVerifaed,
      this.Bio,
      this.Token,
      this.ImageProfile,
      this.Cover});

  UsersModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    ImageProfile = json['ImageProfile'];
    Cover = json['Cover'];
    Bio = json['Bio'];
    Token = json['Token'];
    isEmailVerifaed = json['isEmailVerifaed'];
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
      'isEmailVerifaed': isEmailVerifaed,
    };
  }
}
