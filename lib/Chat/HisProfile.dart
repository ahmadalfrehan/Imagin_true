import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../Chat/Cubit/cubit.dart';
import '../Chat/Cubit/states.dart';
import '../modulo/usersmoder.dart';

class HisProfile extends StatelessWidget {
  UsersModel users;

  HisProfile(this.users);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var scaff = ScaffoldMessenger.of(context);
    return BlocProvider(
      create: (BuildContext context) => ChatCubit()..getUsers(),
      child: BlocConsumer<ChatCubit, SocialStates>(
        listener: (context, state) {
          if (state is SocialDownLoadFileSavedStates) {
            scaff.showSnackBar(
              SnackBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                content: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(55),
                        color: Colors.green,
                      ),
                      child: const Center(
                        child: Text("The File Saved successfully"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is SocialDownLoadFileSavedErrorStates) {
            scaff.showSnackBar(
              SnackBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                content: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(55),
                        color: Colors.green,
                      ),
                      child: const Center(
                        child: Text("an error occurred !"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          var UserModell = ChatCubit.get(context).UU;
          File? image = ChatCubit.get(context).imageProfile;
          if (UserModell != null) {}
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(236, 240, 243, 1),
            ),
            body: Container(
              color: const Color.fromRGBO(236, 240, 243, 1),
              child: ListView(
                children: [
                  if (state is SocialUpdateUserLoadingStates)
                    const LinearProgressIndicator(),
                  if (state is SocialUpdateUserLoadingStates)
                    const SizedBox(
                      height: 4,
                    ),
                  Stack(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(users.Cover.toString()),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ChatCubit.get(context)
                                  .SaveFile(Url: users.Cover.toString());
                            },
                            child: const CircleAvatar(
                              child: Icon(Icons.download),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: (size.width * 0.3) - 1,
                            left: (size.width * 0.34) - 10),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 84,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage: NetworkImage(
                                      users.ImageProfile.toString())),
                            ),
                            GestureDetector(
                              onTap: () {
                                ChatCubit.get(context).SaveFile(
                                    Url: users.ImageProfile.toString());
                              },
                              child: const CircleAvatar(
                                child: Icon(Icons.download),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            users.name.toString(),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        users.Bio.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
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
                                  border:
                                      Border.all(color: Colors.black, width: 1),
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
                                    SelectableText(users.phone.toString()),
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
                                  border:
                                      Border.all(color: Colors.black, width: 1),
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
                                    SelectableText(users.email.toString()),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
