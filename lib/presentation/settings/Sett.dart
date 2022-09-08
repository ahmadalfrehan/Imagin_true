import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Chat/Cubit/cubit.dart';
import '../Chat/Cubit/states.dart';
import '../EditP/EditProfileScreen.dart';
import '../login/login_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var UserModel = ChatCubit.get(context).UU;
    return BlocProvider(
      create: (BuildContext context) => ChatCubit()..getUsers(),
      child: BlocConsumer<ChatCubit, SocialStates>(
        listener: (context, state) {},   
        builder: (context, state) {
          if (UserModel == null) {
            return const Center(
              child: Text(''),
            );
          }
          return Container(
            child: state is SocialGetUserLoadingStates
                ? const LinearProgressIndicator()
                : ListView(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(UserModel.Cover.toString()),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                          ),
                          Container(
                            margin: size.width >= 500
                                ? EdgeInsets.only(
                                top: (size.width * 0.15) - 1,
                                left: (size.width * 0.4) - 10)
                                : EdgeInsets.only(
                                top: (size.width * 0.3) - 1,
                                left: (size.width * 0.32) - 10),
                            child: CircleAvatar(
                              radius: 84,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 80,
                                backgroundImage: NetworkImage(
                                  UserModel.ImageProfile.toString(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                UserModel.name.toString(),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            UserModel.Bio.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 30),
                          const SizedBox(
                            width: 5,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        const Icon(Icons.phone),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Text(UserModel.phone.toString()),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        const Icon(Icons.email),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Text(UserModel.email.toString()),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
