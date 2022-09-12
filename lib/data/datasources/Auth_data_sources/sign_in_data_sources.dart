import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:imagin_true/data/model/ResponseFromModel.dart';
import 'package:imagin_true/domain/repository/AuthRepository/LoginRepository.dart';

class SignInDataSources extends LoginRepository {
  @override
  Future<Either<ResponseFromModel, String>> signIn({
    required String email,
    required String password,
  }) async {
    ResponseFromModel? responseFromModel;
    try {
      UserCredential response =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String bearer = await FirebaseAuth.instance.currentUser!.getIdToken();
      print("Bearer: " + bearer.toString());
      log('response in data source' + response.toString());
      User? user = response.user;
      responseFromModel = ResponseFromModel(
        token: bearer,
        uId: user!.uid,
      );
      return Left(responseFromModel);
    } catch (error) {
      return Right(error.toString());
    }
  }

  @override
  Future<Either<String, String>> forgotPassword(String email) async {
    try {
      var response = FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return Left(response.toString());
    } catch (error) {
      return Right(error.toString());
    }
  }
}
