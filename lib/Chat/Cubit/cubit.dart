import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/Chat/Cubit/states.dart';
import '../../constant.dart';
import '../../modulo/chatModel.dart';
import '../../modulo/usersmoder.dart';

class ChatCubit extends Cubit<SocialStates> {
  ChatCubit() : super(SocialInitialStates());

  static ChatCubit get(context) => BlocProvider.of(context);
  List<UsersModel> users = [];
  UsersModel? UU;

  void getUsers() {
    emit(SocialGetUserLoadingStates());
    FirebaseFirestore.instance
        .collection('chatusers')
        .doc(uId)
        .get()
        .then((value) {
      UU = UsersModel.fromJson(value.data() as Map<String, dynamic>);
      print(
        value.data().toString(),
      );
      emit(
        SocialGetUserSuccessStates(),
      );
    }).catchError((onError) {
      //emit(SocialGetUserErrorStates(onError.toString()));
      print("error" + onError.toString());
    });
  }

  void getUsersAll() {
    emit(SocialGetAllUserLoadingStates());
    FirebaseFirestore.instance.collection('chatusers').get().then((value) {
      emit(SocialGetLikeSuccessState());
      value.docs.forEach((element) {
        if (element.data()['uId'] != uId)
          users.add(UsersModel.fromJson(element.data()));
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
    print(reciverID);
    print(text);
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
}
