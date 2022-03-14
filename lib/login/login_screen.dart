import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/main.dart';
import '../Chat/chat.dart';
import '../register/register_screen.dart';
import '../sharedHELper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var scaff = ScaffoldMessenger.of(context);
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            Shard.saveData(key: 'uId', value: state.uId).then((value) {
              print('uid saved successfully');
              print(state.uId);
              print(Shard.getData(key: 'uId').toString());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  Chat(),
                ),
              );
              Timer(Duration(seconds: 2), () =>main(),);
            });
            scaff.showSnackBar(
              SnackBar(
                content: const Text("success"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: scaff.hideCurrentSnackBar,
                ),
              ),
            );
          } else if (state is LoginErrorState) {
            scaff.showSnackBar(
              SnackBar(
                content: Text(state.error),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: scaff.hideCurrentSnackBar,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                  // color: Color.fromARGB(255, 255, 255, 225),
                  ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: Column(
                  children: [
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      "Sign up to get started ",
                      style: TextStyle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'Email'),
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'the Email must not be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                            // hoverColor: Colors.green,
                            prefixIcon: const Icon(
                              Icons.lock,

                              // color: Colors.teal,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'Password'),
                        controller: passController,
                        keyboardType: TextInputType.text,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'the password must not be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: const BoxDecoration(),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(),
                          elevation: 7,
                          shape: const StadiumBorder(side: BorderSide()),
                          fixedSize: const Size(300, 50),
                        ),
                        onPressed: () {
                          // if (formKey.currentState!.validate())
                          // {
                          LoginCubit.get(context).userLogin(
                            email: emailController.text,
                            password: passController.text,
                          );
                          // }
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Don't have an account?",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        primary: Colors.white,
                        elevation: 7,
                        shape: const StadiumBorder(side: BorderSide()),
                        fixedSize: const Size(300, 50),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                          (route) {
                            return false;
                          },
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        FirebaseAuth.instance.sendPasswordResetEmail(email: 'ahmadfrehan333@gmail.com');
                      },
                      child: const Text(
                        "reset password ?",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
