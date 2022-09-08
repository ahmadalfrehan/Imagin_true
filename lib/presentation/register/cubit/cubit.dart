import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/data/datasources/Auth_data_sources/create_user_data_sources.dart';
import 'package:imagin_true/data/model/UserModel.dart';
import 'package:imagin_true/presentation/register/cubit/states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var numberController = TextEditingController();
  var facebookController = TextEditingController();
  var isAbscure = true;

  createUser(UserModel userModel) async {
    CreateUserDataSources createUserDataSources = CreateUserDataSources();
    emit(RegisterLoadingState());
    var result = await createUserDataSources.createUser(userModel);
    result.fold(
      (l) => {
        emit(RegisterSuccessState(l)),
        log(l.token.toString()),
        log(l.uId.toString()),
      },
      (r) => {
        emit(RegisterErrorState(r.toString())),
        log(r.toString()),
      },
    );
  }
}
