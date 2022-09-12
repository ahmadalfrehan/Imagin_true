import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/data/model/UserModel.dart';
import 'package:imagin_true/presentation/Home/HomeScreen.dart';
import 'package:imagin_true/presentation/Widgets/SnackBar.dart';
import 'package:imagin_true/presentation/Widgets/TextInputField.dart';
import 'package:imagin_true/presentation/sharedHELper.dart';

import '../../app/Config/Config.dart';
import '../login/login_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (BuildContext context) => RegisterCubit(),
        child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) {
            if (state is RegisterSuccessState) {
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
            } else if (state is RegisterErrorState) {
              ShowSnackBar.showSnackBar(
                  context: context,
                  message: 'An Error Occurred try Again',
                  color: Colors.red);
            }
          },
          builder: (context, state) {
            var register = RegisterCubit.get(context);
            return SafeArea(
              child: Container(
                color: isDark
                    ? Color.fromRGBO(23, 32, 44, 1)
                    : Color.fromRGBO(244, 244, 250, 1),
                child: Form(
                  key: RegisterCubit.get(context).formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 0),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          TextInputField(
                            hint: 'name',
                            controller: register.nameController,
                            iconData: Icon(Icons.person),
                          ),
                          TextInputField(
                            hint: 'email',
                            controller: register.emailController,
                            iconData: Icon(Icons.email),
                          ),
                          TextInputField(
                            hint: 'password',
                            isPassword: true,
                            controller: register.passController,
                            iconData: Icon(Icons.password),
                          ),
                          TextInputField(
                            hint: 'phone number',
                            controller: register.numberController,
                            iconData: Icon(Icons.numbers),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: MaterialButton(
                          height: 50,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          minWidth: double.infinity,
                          color: isDark ? Colors.grey.shade800 : Colors.orange,
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            if (register.formKey.currentState!.validate()) {
                              register.createUser(UserModel(
                                name: register.nameController.text,
                                phone: register.numberController.text,
                                uId: uId,
                                Bio: 'gggg',
                                email: register.emailController.text,
                                coverPicturePrivacy: '',
                                BioPrivacy: '',
                                emailAddressPrivacy: '',
                                Cover: '',
                                phoneNumberPrivacy: '',
                                profilePicturePrivacy: '',
                                Token: '',
                                ImageProfile: '',
                                password: register.passController.text,
                              ));
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                                (route) {
                                  return false;
                                },
                              );
                            },
                            child: Text('Login'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
