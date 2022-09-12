import 'package:dartz/dartz.dart';
import 'package:imagin_true/app/Config/error.dart';

import '../../data/model/UserModel.dart';

abstract class GetUsersRepository {
  Future<Either<UserModel, Failure>> getAllUsers();
}
