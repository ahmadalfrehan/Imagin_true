import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/presentation/Widgets/TextInputField.dart';
import 'package:imagin_true/presentation/Widgets/showBottom.dart';

import '../../app/Config/Config.dart';
import '../Home/HomeScreen.dart';
import '../Widgets/SnackBar.dart';
import '../register/register_screen.dart';
import '../sharedHELper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            ShowSnackBar.showSnackBar(
                context: context, message: 'Success', color: Colors.green);
            Shard.saveData(key: 'uId', value: state.responseFromModel.uId);
            Shard.saveData(key: 'token', value: state.responseFromModel.token)
                .then((value) {
              uId = state.responseFromModel.uId;

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Earth()),
                  (route) => false);
            });
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Earth()),
                (route) => false);
          } else if (state is LoginErrorState) {
            ShowSnackBar.showSnackBar(
                context: context,
                message: 'An Error Occurred try Again',
                color: Colors.red);
          }
        },
        builder: (context, state) {
          var login = LoginCubit.get(context);
          return Scaffold(
              key: LoginCubit.get(context).Scaffoldkey,
              body: SafeArea(
                child: Container(
                  color: isDark
                      ? Color.fromRGBO(23, 32, 44, 1)
                      : Color.fromRGBO(244, 244, 250, 1),
                  child: Form(
                    key: login.formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextInputField(
                                hint: 'email',
                                controller: login.emailController,
                                iconData: Icon(Icons.email),
                              ),
                              TextInputField(
                                hint: 'password',
                                controller: login.passController,
                                iconData: Icon(Icons.password),
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: MaterialButton(
                              height: 50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              minWidth: double.infinity,
                              color:
                                  isDark ? Colors.grey.shade800 : Colors.orange,
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                if (login.formKey.currentState!.validate()) {
                                  LoginCubit.get(context).userLogin(
                                    email: login.emailController.text,
                                    password: login.passController.text,
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    ShowBottom.showBottom(login.Scaffoldkey,
                                        login.ResetpassController, () {
                                      print('object');
                                      login.forgotPassword(
                                          email:
                                              login.ResetpassController.text);
                                    });
                                  },
                                  child: const Text(
                                    "Forgot password",
                                    style: TextStyle(
                                      //fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                textAlign: TextAlign.center,
                              ),
                              TextButton(
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
                                  child: Text('Sign up'))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
