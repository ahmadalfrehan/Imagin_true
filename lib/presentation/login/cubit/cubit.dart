
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/presentation/login/cubit/states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  userLogin({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      emit(LoginSuccessState(value.user!.uid));
      print('amva');
    }).catchError((onError) {
      emit(LoginErrorState(onError.toString()));
      print("slbnsonbaso;w" + onError.toString());
    });
  }

  bool ChangeBool(var c, var y) {
    emit(ChangePasswordVisibilityState());
    c = y;
    return c;
  }
}
