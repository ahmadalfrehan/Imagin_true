import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/data/datasources/Auth_data_sources/sign_in_data_sources.dart';
import 'package:imagin_true/presentation/login/cubit/states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var ResetpassController = TextEditingController();
  var Scaffoldkey = GlobalKey<ScaffoldState>();
  bool isAbscure = true;
  SignInDataSources signInDataSources = SignInDataSources();

  userLogin({
    required String email,
    required String password,
  }) async {
    var result = await signInDataSources.signIn(
      email: email,
      password: password,
    );
    result.fold(
        (l) => {
              emit(LoginSuccessState(l)),
              log(l.token.toString()),
              log(l.uId.toString()),
            },
        (r) => {
              log(r),
              emit(LoginErrorState(r.toString())),
            });
  }

  forgotPassword({required String email}) async {
    var result = await signInDataSources.forgotPassword(email);
    result.fold(
        (l) => {
              debugPrint(l),
            },
        (r) => {
              debugPrint(r),
            });
  }

  bool ChangeBool(var c, var y) {
    emit(ChangePasswordVisibilityState());
    c = y;
    return c;
  }
}
