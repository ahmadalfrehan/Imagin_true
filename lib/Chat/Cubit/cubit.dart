import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagin_true/Chat/Cubit/states.dart';
import 'package:imagin_true/Chat/chat.dart';
import 'package:imagin_true/Contact/Contact.dart';
import 'package:imagin_true/settings/Sett.dart';
import '../../constant.dart';
import '../../modulo/chatModel.dart';
import '../../modulo/usersmoder.dart';

class ChatCubit extends Cubit<SocialStates> {
  ChatCubit() : super(SocialInitialStates());

  static ChatCubit get(context) => BlocProvider.of(context);
  List<UsersModel> users = [];
  UsersModel? UU;
  List titles = [
    'Chat',
    'Contacts',
    'settings',
  ];
  List screens = [
    Chat(),
    const Contactss(),
    const SettingScreen(),
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
  }) {
    ChatModel modelChat = ChatModel(
      text: text,
      SenderID: UU!.uId as String,
      reciverID: reciverID,
      dateTime: dateTime,
    );
    FirebaseFirestore.instance
        .collection('users')
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
        .collection('users')
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
        .collection('users')
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
      emit(SocialGetMessageSuccessStates());
    });
  }

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
        .child('users/${Uri.file(imageProfile!.path).pathSegments.last}')
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
        .child('users/${Uri.file(imageCover!.path).pathSegments.last}')
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
          .collection('users')
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
}
