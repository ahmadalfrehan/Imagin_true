import 'package:dartz/dartz.dart';

import '../../data/model/UsersModel.dart';

abstract class GetUsersUseCase {
  Future<Either<List<UsersModel>, String>> getAllUsers();

  Future<Either<UsersModel?, String>> getUser();

  Future<Either<List<String>, String>> getContacts();

  Future<Either<List<UsersModel>, String>> filterUsers();

  Future<Either<List<UsersModel>, String>> cashedUsers();
}
