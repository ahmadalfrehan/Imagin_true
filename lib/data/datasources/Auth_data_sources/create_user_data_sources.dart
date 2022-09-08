import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:imagin_true/data/model/ResponseFromModel.dart';
import 'package:imagin_true/domain/repository/AuthRepository/RegisterRepository.dart';

import '../../model/UserModel.dart';

class CreateUserDataSources extends RegisterRepository {
  @override
  Future<Either<ResponseFromModel, String>> createUser(
      UserModel userModel) async {
    ResponseFromModel? responseFromModel;
    try {
      UserCredential response = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userModel.email.toString(),
              password: userModel.password.toString());
      String bearer = await FirebaseAuth.instance.currentUser!.getIdToken();
      print("Bearer: " + bearer.toString());
      log('response in data source' + response.toString());
      User? user = response.user;
      await FirebaseFirestore.instance
          .collection('chatusers')
          .doc(user?.uid)
          .set(userModel.toMap());
      responseFromModel = ResponseFromModel(
        token: bearer,
        uId: user!.uid,
      );
      return Left(responseFromModel);
    } catch (Error) {
      return Right(Error.toString());
    }
  }
}
