import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/Config/Config.dart';
import '../Home/HomeScreen.dart';
import '../constant.dart';
import '../../main.dart';
import '../register/register_screen.dart';
import '../sharedHELper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var ResetpassController = TextEditingController();
  var Scaffoldkey = GlobalKey<ScaffoldState>();
  bool isAbscure = true;

  @override
  Widget build(BuildContext context) {
    var scaff = ScaffoldMessenger.of(context);
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            Shard.saveData(key: 'uId', value: state.uId).then((value) {
              uId = Shard.sharedprefrences!.getString('uId');
              Timer(
                const Duration(seconds: 1),
                () => main(),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Earth(),
                ),
              );
            });
            scaff.showSnackBar(
              SnackBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                content: Column(
                  children: [
                    const SizedBox(
                      height: 250,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(55),
                        color: Colors.green,
                      ),
                      child: const Center(
                        child: Text(
                          "Success",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is LoginErrorState) {
            scaff.showSnackBar(
              SnackBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                content: Column(
                  children: [
                    const SizedBox(
                      height: 250,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(55),
                        color: Colors.red,
                      ),
                      child: const Center(
                        child: Text("An error occurred try again !"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: Scaffoldkey,
            body: Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                  // color: Color.fromARGB(255, 255, 255, 225),
                  ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                  child: Column(
                    children: [
                       Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color:!isDark ? Colors.black : Color(0xFFECF0F3),
                        ),
                      ),
                      const Text(
                        "login to get started ",
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
                      //        fillColor: Colors.white,
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
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    isAbscure
                                        ? isAbscure = LoginCubit.get(context)
                                            .ChangeBool(isAbscure, false)
                                        : isAbscure = LoginCubit.get(context)
                                            .ChangeBool(isAbscure, true);
                                  },
                                  child: isAbscure
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility)),
                              prefixIcon: const Icon(
                                Icons.lock,
                                // color: Colors.teal,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                        //      fillColor: Colors.white,
                              filled: true,
                              labelText: 'Password'),
                          controller: passController,
                          obscureText: isAbscure,
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
                            primary: isDark ? Colors.grey.shade800 : Colors.orange,
                            elevation: 7,
                            shape: const StadiumBorder(side: BorderSide()),
                            fixedSize: const Size(300, 50),
                          ),
                          onPressed: () {
                            // if (formKey.currentState!.validate())
                            // {
                            if(formKey.currentState!.validate()){
                            LoginCubit.get(context).userLogin(
                              email: emailController.text,
                              password: passController.text,
                            );
                            }
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
                            color: Colors.black
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Scaffoldkey.currentState!
                              .showBottomSheet(
                                (context) => Scaffold(
                                  body: Container(
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: TextFormField(
                                            controller: ResetpassController,
                                            decoration: InputDecoration(
                                              label:
                                                  const Text("write your email"),
                                              //fillColor: Colors.white,
                                              filled: true,
                                              enabled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            keyboardType: TextInputType.text,
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'the field must not be empty';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            FirebaseAuth.instance
                                                .sendPasswordResetEmail(
                                                    email:
                                                        ResetpassController.text);
                                          },
                                          child: const Text('Send ? '),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .closed;
                        },
                        child: const Text(
                          "Forgot password ?",
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
            ),
          );
        },
      ),
    );
  }
}
