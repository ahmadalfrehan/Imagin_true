import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagin_true/presentation/Chat/Cubit/states.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/Config/Config.dart';
import '../../Contact/Contact.dart';
import '../../modulo/chatModel.dart';
import '../../modulo/usersmoder.dart';
import '../../settings/Sett.dart';
import '../../settings/Settings.dart';
import '../../sharedHELper.dart';
import '../All.dart';
import '../chat.dart';

class ChatCubit extends Cubit<SocialStates> {
  ChatCubit() : super(SocialInitialStates());

  static ChatCubit get(context) => BlocProvider.of(context);
  List<UsersModel> users = [];
  List<UsersModel> Allusers = [];
  UsersModel? UU;
  List titles = [
    'Chat',
    'All Users',
    'Contacts',
    'My Profile',
    'Settings',
  ];
  List screens = [
    Chat(),
    AllU(),
    const Contactss(),
    const SettingScreen(),
    SettingsS(),
  ];
  int Cindex = 0;

  void ChangeBottomSheet(int index) {
    Cindex = index;
    emit(SocialChangeBottomNavStates());
  }

  void getUsers() {
    emit(SocialGetUserLoadingStates());
    FirebaseFirestore.instance
        .collection('chatusers')
        .doc(uId)
        .get()
        .then((value) {
      UU = UsersModel.fromJson(value.data() as Map<String, dynamic>);
      emit(
        SocialGetUserSuccessStates(),
      );
    }).catchError((onError) {
      //emit(SocialGetUserErrorStates(onError.toString()));
      print("error" + onError.toString());
    });
  }

  List<String> names = [];
  List<String> phones = [];
  Iterable<Contact>? contactslist;

  Future<void> getContacts() async {
    emit(SocialGetContactsSuccessStates());
  }

  void getUsersAll() async {
    emit(SocialGetAllUserLoadingStates());
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    contactslist = contacts;
    contacts.forEach((contact) {
      contact.phones!.toSet().forEach((phone) {
        phones.add(phone.value.toString());
      });
    });
    FirebaseFirestore.instance.collection('chatusers').get().then((value) {
      emit(SocialGetAllUserSuccessStates());
      value.docs.forEach((element) {
        if (element.data()['uId'] != uId) {
          for (int i = 0; i < phones.length; i++) {
            if (element.data()['phone'] ==
                phones[i].trim().replaceAll(' ', '')) {
              users.add(UsersModel.fromJson(element.data()));
            }
          }
        }
      });
    }).catchError((onError) {
      emit(SocialGetAllUserErrorStates(onError.toString()));
    });
  }

  void getAllUsersWithOutRelat() async {
    emit(SocialGetAllUserWithOutRealtionLoadingStates());
    FirebaseFirestore.instance.collection('chatusers').get().then((value) {
      emit(SocialGetAllUserWithOutRealtionSuccessStates());
      value.docs.forEach((element) {
        if (element.data()['uId'] != uId) {
          Allusers.add(UsersModel.fromJson(element.data()));
        }
      });
    }).catchError((onError) {
      emit(SocialGetAllUserWithOutRealtionErrorStates(onError().toString()));
    });
  }

  void SendMessaege({
    required String reciverID,
    required String text,
    required String dateTime,
    required bool isRead,
    String? Url,
  }) {
    ChatModel modelChat = ChatModel(
      text: text,
      SenderID: UU!.uId as String,
      reciverID: reciverID,
      dateTime: dateTime,
      isRead: isRead,
      Url: Url ?? "",
    );
    FirebaseFirestore.instance
        .collection('chatusers')
        .doc(UU!.uId)
        .collection('chats')
        .doc(reciverID)
        .collection('messages')
        .add(modelChat.toMap())
        .then((value) {
      print(55555);
      emit(SocialSendMessageSuccessStates());
    }).catchError((onError) {
      emit(SocialSendMessageErrorStates(onError.toString()));
    });
    FirebaseFirestore.instance
        .collection('chatusers')
        .doc(reciverID)
        .collection('chats')
        .doc(UU!.uId)
        .collection('messages')
        .add(modelChat.toMap())
        .then((value) {
      print(55555);
      emit(SocialSendMessageSuccessStates());
    }).catchError((onError) {
      emit(SocialSendMessageErrorStates(onError.toString()));
    });
  }

  List<ChatModel> messages = [];

  void getMessages({required String reciverID}) {
    emit(SocialGetMessageSuccessStates());
    FirebaseFirestore.instance
        .collection('chatusers')
        .doc(UU?.uId)
        .collection('chats')
        .doc(reciverID)
        .collection('messages')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(ChatModel.fromJson(element.data()));
      });
      //emit(SocialGetMessageSuccessStates());
    });
  }

/*
  List<String> s = [];

  void Fill({required String reciverID}) {
    FirebaseFirestore.instance
        .collection('chatusers')
        .doc(UU?.uId)
        .collection('chats')
        .doc(reciverID)
        .collection('messages')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        s.add(element.id);
      });
      print(s);
    });
  }

  void UpdateMessages({
    required String text,
    required String dateTime,
    required String reciverID,
    required bool isRead,
  }) {
    Fill(reciverID: reciverID);
    print('llflfll');
    ChatModel c = ChatModel(
      reciverID: reciverID,
      text: text,
      SenderID: UU?.uId as String,
      dateTime: dateTime,
      isRead: isRead,
      Url: '',
    );
    print('n+1');
    for (int i = 0; i < s.length; i++) {
      FirebaseFirestore.instance
          .collection('chatusers')
          .doc(UU?.uId)
          .collection('chats')
          .doc(reciverID)
          .collection('messages')
          .doc(s[i].toString())
          .update({'isRead':true})
          .then((value) {
        print('success');
        emit(SocialUpdateMessageSuccessStates());
        getMessages(reciverID: reciverID);
        print('Successsssss');
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  List latestMesaage = [];
  List latestMesaage2 = [];

  getLatestMessage({required String reciverID}) {
    emit(SocialGetMessageSuccessStates());
    FirebaseFirestore.instance
        .collection('chatusers')
        .doc(UU?.uId)
        .collection('chats')
        .doc(reciverID)
        .collection('messages')
        .orderBy('dateTime', descending: true)
        .limit(1)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        latestMesaage2.add(UsersModel.fromJson(element.data()));
      });
    });
  }

  void ClearWithMix() {
    print(latestMesaage2);
  }
*/
  var imageProfile;
  final Picker = ImagePicker();

  getImageProfile(ImageSource sre) async {
    final Pac = await Picker.pickImage(source: sre);
    emit(SocialImagePickedProfileSuccessStates());
    if (Pac != null) {
      imageProfile = File(Pac.path);
    } else {
      emit(SocialImagePickedProfileErrorStates());
      print('no image selected');
    }
  }

  var imageCover;

  getImageCover(ImageSource sre) async {
    final Pac = await Picker.pickImage(source: sre);
    emit(SocialImagePickedCoverSuccessStates());
    if (Pac != null) {
      imageCover = File(Pac.path);
    } else {
      emit(SocialImagePickedCoverErrorStates());
      print('no imageCovered Selected');
    }
  }

  GetWallPaperImage(ImageSource sre) async {
    final Pac = await Picker.pickImage(source: sre);
    emit(SocialImagePickedWallPaperSuccessStates());
    if (Pac != null) {
      imageCover = File(Pac.path);
    } else {
      emit(SocialImagePickedWallPaperErrorStates());
      print('no imageCovered Selected');
    }
  }

  String? PrifileImageUrl;
  String? CoverImageUrl;

  void uploadProfileImage() {
    emit(SocialUploadImageProfileLoadingStates());
    FirebaseStorage.instance
        .ref()
        .child('chatusers/${Uri.file(imageProfile!.path).pathSegments.last}')
        .putFile(imageProfile)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        emit(SocialUploadImageProfileSuccessStates());
        PrifileImageUrl = value;
      }).catchError((onError) {
        print("errrrrrrrrrrrrrrrooooooor" + onError.toString());
        emit(SocialUploadImageProfileErrorStates());
      });
    }).catchError((onError) {
      print("error" + onError.toString());
      emit(SocialUploadImageProfileErrorStates());
    });
  }

  void uploadCoverImage() {
    emit(SocialUploadImageCoverLoadingStates());
    FirebaseStorage.instance
        .ref()
        .child('chatusers/${Uri.file(imageCover!.path).pathSegments.last}')
        .putFile(imageCover)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        emit(SocialUploadImageCoverSuccessStates());
        CoverImageUrl = value;
      }).catchError((onError) {
        print("errrrrrrrrrrrrrrrooooooor" + onError.toString());
        emit(SocialUploadImageCoverErrorStates());
      });
    }).catchError((onError) {
      print("error" + onError.toString());
      emit(SocialUploadImageCoverErrorStates());
    });
  }

  void UpdateUser({
    required String name,
    required String phone,
    required String bio,
  }) async {
    {
      var token = await FirebaseMessaging.instance.getToken();
      emit(SocialUpdateUserLoadingStates());
      UsersModel UserModelUpdate = UsersModel(
        name: name == "" ? UU!.name : name,
        phone: phone == "" ? UU!.phone : phone,
        Bio: bio == "" ? UU!.Bio : bio,
        email: UU!.email,
        uId: UU!.uId,
        Cover: CoverImageUrl ?? UU!.Cover,
        ImageProfile: PrifileImageUrl ?? UU!.ImageProfile,
        Token: token.toString(),
        phoneNumberPrivacy: UU?.phoneNumberPrivacy,
        emailAddressPrivacy: UU?.emailAddressPrivacy,
        profilePicturePrivacy: UU?.profilePicturePrivacy,
        coverPicturePrivacy: UU?.coverPicturePrivacy,
        BioPrivacy: UU?.BioPrivacy,
      );
      FirebaseFirestore.instance
          .collection('chatusers')
          .doc(uId)
          .update(UserModelUpdate.toMap())
          .then((value) {
        getUsers();
      }).catchError((onError) {
        print(onError.toString());
      });
    }
  }

  String? privacySelectionProfilePicture;
  String? privacySelectionEmailAddress;
  String? privacySelectionPhoneNumber;
  String? privacySelectionBio;
  String? privacySelectionCoverPictures;

  void UpdateUserPrivacy() async {
    var token = await FirebaseMessaging.instance.getToken();
    print(UU);
    emit(SocialUpdateUserPrivacyLoadingStates());
    UsersModel UserModelUpdatePrivacy = UsersModel(
      name: UU!.name,
      phone: UU!.phone,
      Bio: UU!.Bio,
      email: UU!.email,
      uId: UU!.uId,
      Cover: CoverImageUrl ?? UU!.Cover,
      ImageProfile: PrifileImageUrl ?? UU!.ImageProfile,
      Token: token.toString(),
      BioPrivacy: privacySelectionBio ?? UU?.BioPrivacy,
      coverPicturePrivacy:
          privacySelectionCoverPictures ?? UU?.coverPicturePrivacy,
      profilePicturePrivacy:
          privacySelectionProfilePicture ?? UU?.profilePicturePrivacy,
      emailAddressPrivacy:
          privacySelectionEmailAddress ?? UU?.emailAddressPrivacy,
      phoneNumberPrivacy: privacySelectionPhoneNumber ?? UU?.phoneNumberPrivacy,
    );
    FirebaseFirestore.instance
        .collection('chatusers')
        .doc(uId)
        .update(UserModelUpdatePrivacy.toMap())
        .then((value) {
      emit(SocialUpdateUserPrivacySuccessStates());
      getUsers();
    }).catchError((onError) {
      emit(SocialUpdateUserPrivacyErrorStates());
      print(onError.toString());
    });
  }

  var PostImagee;

  getImagePost(ImageSource sre) async {
    final Pac = await Picker.pickImage(source: sre);
    emit(SocialImagePickedCoverSuccessStates());
    if (Pac != null) {
      PostImagee = File(Pac.path);
    } else {
      emit(SocialImagePickedCoverErrorStates());
      print('no PostImageed Selected');
    }
  }

  CreateFolder() async {
    const folderName = "Ahmad_Al_Frehan";
    final path = Directory("storage/emulated/0/$folderName");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }

  File? file;

  void getFiles() async {
    //CreateFolder();
    var result;
    //FilePickerResult result =
    //  await FilePicker.platform.pickFiles() as FilePickerResult;
    if (result != null) {
      file = File(result.files.single.path.toString());
      print(file!.path);
    } else {
      print('canceled');
    }
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    var file2 = basename(file!.path);
    final File newFile =
        await file!.copy('storage/emulated/0/download/file.$file2');
    print(directory);
    print(newFile.path);
  }

  var dio = Dio();

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  SaveFile({required String Url}) {
    emit(SocialDownLoadFileLoadingStates());

    String name = generateRandomString(26);
    print(name);
    emit(SocialDownLoadFileSavedStates());
    String type = Url.split('.').last.substring(0, 3);
    try {
      dio.downloadUri(
          Uri.parse(Url), "storage/emulated/0/download/$name.$type");
    } catch (e) {
      emit(SocialDownLoadFileSavedErrorStates());
      print(e);
    }
  }

  bool isarabic = false;

  void isArabic(String s) {
    for (int i = 0; i < s.length; i++) {
      List<int> c = s.codeUnits;
      emit(SocialChangeLTRSuccessStates());
      if (c[0] >= 1575 && c[0] <= 1610) {
        isarabic = true;
      } else {
        isarabic = false;
      }
    }
  }

  String? SendFile;

  uploadFile({
    required String reciverID,
    required String text,
    required String dateTime,
    required bool isRead,
  }) {
    emit(SocialUploadFileLoadingStates());
    FirebaseStorage.instance
        .ref()
        .child('chatusers/${Uri.file(file!.path).pathSegments.last}')
        .putFile(file!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        SendMessaege(
          reciverID: reciverID,
          text: text,
          dateTime: dateTime,
          isRead: isRead,
          Url: value,
        );
        emit(SocialUploadFileSuccessStates());
        SendFile = value;
      }).catchError((onError) {
        print("error" + onError.toString());
        emit(SocialUploadFileErrorStates());
      });
    }).catchError((onError) {
      print("error" + onError.toString());
      emit(SocialUploadFileErrorStates());
    });
  }

  double? FontSized;
  List<double> fontS = [10, 22, 30, 40, 60, 80, 90, 100];
  List<String> Phone = ['Every Body', 'No Body'];

  List<String> profilePictures = ['Every Body', 'No Body'];

  List<String> coverPictures = ['Every Body', 'No Body'];

  List<String> Bio = ['Every Body', 'No Body'];

  List<String> emailAdr = ['Every Body', 'No Body'];

  void ChangeFont(double val) async {
    fontSize = val;
    emit(SocialChangeFontSuccessStates());
    await Shard.saveData(
      key: 'FontSized',
      value: fontSize,
    );
    print('fontSvaed');
  }

  void ChangeVarPrivacyEmailAddress(String val) async {
    privacySelectionEmailAddress = val;
    emit(SocialChangeVarStates());
  }

  void ChangeVarPrivacyProfilePicture(String val) async {
    privacySelectionProfilePicture = val;
    emit(SocialChangeVarStates());
  }

  void ChangeVarPrivacyPhoneNumber(String val) async {
    privacySelectionPhoneNumber = val;
    emit(SocialChangeVarStates());
  }

  void ChangeVarPrivacyBio(String val) async {
    privacySelectionBio = val;
    emit(SocialChangeVarStates());
  }

  void ChangeVarPrivacyCoverPictures(String val) async {
    privacySelectionCoverPictures = val;
    emit(SocialChangeVarStates());
  }

  bool isS = true;
  var scroll = ScrollController();

  void scrolltoDown() {
    emit(SocialisAutoScrollingStates());
    if (scroll.hasClients) {
      scroll.jumpTo(scroll.position.maxScrollExtent);
    }
  }

  bool ChangeVar(var x, var y) {
    emit(SocialChangeVarStates());
    print(y);
    x = y;
    print(x);
    return x;
  }

  void scrollToTop(bool isAutoScrolling) {
    emit(SocialisAutoScrollingStates());
    if (isAutoScrolling) {
      if (scroll.hasClients) {
        scroll.jumpTo(scroll.position.minScrollExtent);
      }
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    emit(SocialmakePhoneCallStates());
    final LaunchUrl = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(LaunchUrl.toString());
  }

  makeEmailCall(String emailAd) async {
    emit(SocialmakePhoneCallStates());
    final LaunchUrl = Uri(
      scheme: 'mailto',
      path: emailAd,
    );
    await launch(LaunchUrl.toString());
  }

  String? encodeQueryParametr(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)} = ${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  LaunchUrl(String Url) async {
    emit(SocialmakePhoneCallStates());
    await launch(Url);
  }

  makeMessage(String phoneNumber) async {
    emit(SocialmakePhoneCallStates());
    final LaunchUrl =
        'sms:${phoneNumber}?body=hello%20there i\'m using imagin_true to chat - We invite you to join us! Get it on google play :https://play.google.com/store/apps/details?id=com.ahmad_alfrehan.imagin_true';
    await launch(LaunchUrl.toString());
  }

  void SavedDark(bool? ISDark, bool value) async {
    ISDark = value;
    emit(SocialChangeDarkModeStates());
    await Shard.saveData(
      key: 'darkMode',
      value: ISDark,
    );
    print('DarkSuc');
  }
}
