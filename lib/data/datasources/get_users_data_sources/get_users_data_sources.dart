import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dartz/dartz.dart';
import 'package:imagin_true/data/model/UsersModel.dart';

import '../../../app/Config/Config.dart';
import '../../../domain/uses_case/getUsersUseCase.dart';

class GetUsersDataSources extends GetUsersUseCase {
  List<String> phones = [];
  Iterable<Contact>? contactsList;
  List<String> names = [];
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

  @override
  Future<Either<List<UsersModel>, String>> getAllUsers() async {
    try {
      FirebaseFirestore.instance.collection('chatusers').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != uId) {
            users.add(UsersModel.fromJson(element.data()));
          }
        });
      });
      print(users);
      return Left(users);
    } catch (error) {
      log('this error in data sources getAllUsers Method' + error.toString());
      return Right(error.toString());
    }
  }
}
