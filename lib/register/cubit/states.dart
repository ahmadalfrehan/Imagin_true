class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  final String error;

  RegisterErrorState(this.error);
}

class CreateSuccessState extends RegisterStates {}

class CreateErrorState extends RegisterStates {
  final String error;

  CreateErrorState(this.error);
}

class RegisterChangePasswordVisibilityState extends RegisterStates {}



