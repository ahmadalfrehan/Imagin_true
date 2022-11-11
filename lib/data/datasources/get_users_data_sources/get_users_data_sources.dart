import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dartz/dartz.dart';
import 'package:imagin_true/data/model/MessagesModel.dart';
import 'package:imagin_true/data/model/UsersModel.dart';
import '../../../app/Config/Config.dart';
import '../../../domain/uses_case/getUsersUseCase.dart';

class GetUsersDataSources extends GetUsersUseCase {
  List<String> phones = [];
  Iterable<Contact>? contactsList;
  List<String> names = [];
  UsersModel? usersModel;
  List<UsersModel> users = [];

  @override
  Future<Either<List<String>, String>> getContacts() async {
    try {
      final Iterable<Contact> contacts = await ContactsService.getContacts();
      contactsList = contacts;
      contacts.forEach((contact) {
        contact.phones!.toSet().forEach((phone) {
          phones.add(phone.value.toString());
          log(phone.toString());
        });
      });
      return Left(phones);
    } catch (error) {
      log(error.toString());
      return Right(error.toString());
    }
  }

  @override
  Future<Either<List<UsersModel>, String>> cashedUsers() {
    // TODO: implement cashedUsers
    throw UnimplementedError();
  }

  @override
  Future<Either<List<UsersModel>, String>> filterUsers() async {
    getAllUsers();
    getContacts();
    try {
      List<UsersModel> filteredUsers = [];
      print(phones);
      for (int i = 0; i < users.length; i++) {
        if (users[i].phone == phones[i].trim().replaceAll(' ', '')) {
          filteredUsers.add(users[i]);
        }
      }
      print(filteredUsers.toString());
      return Left(filteredUsers);
    } catch (error) {
      log(error.toString());
      return Right(error.toString());
    }
  }

/*
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
  }*/
  @override
  Future<Either<List<UsersModel>, String>> getAllUsers() async {
    try {
    ///  getUser();
      List<MessagesModel> latestMessages = [];
      var r = FirebaseFirestore.instance.collection('chatusers');
      FirebaseFirestore.instance.collection('chatusers').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != uId) {
            r
                .doc(usersModel?.uId)
                .collection('chats')
                .doc('K0Kkwge10jd15NOrAzZZLNZP19K2')
                .collection('messages')
                .orderBy('dateTime', descending: true)
                .limit(1)
                .get()
                .then((value) => value.docs.forEach((element) {
                      log(element.toString());
                      users.add(UsersModel.fromJson(element.data()));
                    }));
            users.add(UsersModel.fromJson(element.data()));
          }
        });
      });
      return Left(users);
    } catch (error) {
      log('this error in data sources getAllUsers Method' + error.toString());
      return Right(error.toString());
    }
  }

  @override
  Future<Either<UsersModel?, String>> getUser() async {
    try {
      FirebaseFirestore.instance
          .collection('chatusers')
          .doc(uId)
          .get()
          .then((value) {
        print(value.data());
        usersModel = UsersModel.fromJson(value.data() as Map<String, dynamic>);
      });
      return Left(usersModel);
    } catch (error) {
      return Right(error.toString());
    }
  }
}
