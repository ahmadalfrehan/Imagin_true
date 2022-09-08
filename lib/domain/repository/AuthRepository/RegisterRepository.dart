import 'package:dartz/dartz.dart';
import 'package:imagin_true/data/model/ResponseFromModel.dart';
import 'package:imagin_true/data/model/UserModel.dart';

abstract class RegisterRepository {
  Future<Either<ResponseFromModel, String>> createUser(UserModel userModel);
}
