import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/login/cubit/states.dart';
import 'package:imagin_true/register/cubit/states.dart';
import '../../modulo/usersmoder.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
    required bool isEmailVerifaed,
  }) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      createUser(
          name: name,
          email: email,
          phone: phone,
          uId: value.user!.uid,
          isEmailVerifaed: isEmailVerifaed);
      emit(RegisterSuccessState());
    }).catchError((onError) {
      emit(RegisterErrorState(onError.toString()));
    });
  }

  var token = FirebaseMessaging.instance.getToken();

  void createUser({
    required String name,
    required String email,
    required String phone,
    required String uId,
    required bool isEmailVerifaed,
  }) async {
    var token = await FirebaseMessaging.instance.getToken();
    UsersModel U = UsersModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      Bio: "Hello There this is my Bio...!",
      Token: token.toString(),
      Cover:
          'https://img.freepik.com/free-vector/meadow-with-pond-conifers-hills-night_107791-10085.jpg?t=st=1645656526~exp=1645657126~hmac=cf22968efb78b6750bffb4fbe5ae7809de6c4cc8e0386dcfc5e9588e520d066f&w=996',
      ImageProfile:
          'https://img.freepik.com/free-vector/hand-painted-watercolor-pastel-sky-background_23-2148902771.jpg?t=st=1645658389~exp=1645658989~hmac=fe73f98251132a14dc413d8dbb45de471a6a4d7f1a5b1adcaefe67789fc5c4f4&w=740',
      isEmailVerifaed: isEmailVerifaed,
    );
    FirebaseFirestore.instance
        .collection('chatusers')
        .doc(uId)
        .set(U.toMap())
        .then((value) {
      emit(CreateSuccessState());
      print('done !');
    }).catchError((onError) {
      emit(CreateErrorState(onError.toString()));
      print(
        "error " + onError.toString(),
      );
    });
  }


  bool ChangeBool(var c, var y) {
    emit(RegisterChangePasswordVisibilityState());
    c = y;
    return c;
  }
}
