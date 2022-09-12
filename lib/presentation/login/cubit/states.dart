import 'package:imagin_true/data/model/ResponseFromModel.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final ResponseFromModel responseFromModel;

  LoginSuccessState(this.responseFromModel);
}

class LoginErrorState extends LoginStates {
  final String error;

  LoginErrorState(this.error);
}

class ChangePasswordVisibilityState extends LoginStates {}
