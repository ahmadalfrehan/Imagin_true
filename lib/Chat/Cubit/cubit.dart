import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagin_true/Chat/Cubit/states.dart';
import 'package:imagin_true/Chat/chat.dart';
import 'package:imagin_true/Contact/Contact.dart';
import 'package:imagin_true/settings/Sett.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Earth.dart';
import '../../constant.dart';
import '../../modulo/chatModel.dart';
import '../../modulo/usersmoder.dart';
import '../../settings/Settings.dart';
import '../../sharedHELper.dart';

class ChatCubit extends Cubit<SocialStates> {
  ChatCubit() : super(SocialInitialStates());

  static ChatCubit get(context) => BlocProvider.of(context);
  List<UsersModel> users = [];
  UsersModel? UU;
  List titles = [
    'Chat',
    'Contacts',
    'My Profile',
    'Settings',
  ];
  List screens = [
    Chat(),
    const Contactss(),
    const SettingScreen(),
    const SettingsS(),
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
      emit(SocialGetLikeSuccessState());
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
      //emit(SocialGetAllUserErrorStates(onError.toString()));
    });
  }

  void SendMessaege({
    required String reciverID,
    required String text,
    required String dateTime,
    String? Url,
  }) {
    ChatModel modelChat = ChatModel(
        text: text,
        SenderID: UU!.uId as String,
        reciverID: reciverID,
        dateTime: dateTime,
        Url: Url ?? "");
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
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(ChatModel.fromJson(element.data()));
      });
      //emit(SocialGetMessageSuccessStates());
    });
  }

  List latestMesaage = [];

  /*getLatestMessage() {
    FirebaseFirestore.instance.collection('chatusers').get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('chatusers')
            .doc(UU?.uId)
            .collection('chats')
            .doc(element.data()['uId'])
            .collection('messages')
            .orderBy('dateTime')
            .snapshots()
            .listen((event) {
          event.docs.forEach((element) {
            latestMesaage.add(ChatModel.fromJson(element.data()));
          });
        });
      });
    });
  }*/

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
  }) {
    {
      emit(SocialUpdateUserLoadingStates());
      UsersModel UserModelUpdate = UsersModel(
        name: name,
        phone: phone,
        Bio: bio,
        email: UU!.email,
        uId: UU!.uId,
        Cover: CoverImageUrl ?? UU!.Cover,
        ImageProfile: PrifileImageUrl ?? UU!.ImageProfile,
        isEmailVerifaed: false,
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
    FilePickerResult result =
        await FilePicker.platform.pickFiles() as FilePickerResult;
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

  SaveFile({required String Url}) {
    emit(SocialDownLoadFileLoadingStates());
    var r = Random();
    String name =
        String.fromCharCodes(List.generate(10, (index) => r.nextInt(65) + 90));
    name = name.trim().replaceAll('\\', 'k');
    name = name.trim().replaceAll('|', 'l');
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
      int c = s.codeUnitAt(i);
      emit(SocialChangeLTRSuccessStates());
      if (c >= 0x0600 && c <= 0x06E0) {
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

  double? FontSized; //Shard.getData(key: 'FontSized');
  List<double> fontS = [
    10,
    22,
    30,
    40,
    60,
    80,
    90,
    100,
  ];

  void ChangeFont(double val) async {
    FontSized = val;
    emit(SocialChangeFontSuccessStates());
    await Shard.saveData(
      key: 'FontSized',
      value: FontSized,
    );
    print('fontSvaed');
  }
  bool isS = true;
  var scroll = ScrollController();
  void scrolltoDown() {
    if (scroll.hasClients) {
      scroll.jumpTo(scroll.position.maxScrollExtent);
    }
  }
}
