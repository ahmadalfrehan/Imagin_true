import 'package:dartz/dartz.dart';

import '../../../data/model/ResponseFromModel.dart';

abstract class LoginRepository {
  Future<Either<ResponseFromModel, String>> signIn(
      {required String email, required String password});

  Future<Either<String, String>> forgotPassword(String email);
}
