import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/Config/Config.dart';
import '../constant.dart';
import '../modulo/usersmoder.dart';
import 'Cubit/cubit.dart';
import 'Cubit/states.dart';
import 'chat_details.dart';

class Chat extends StatelessWidget {
  Chat();

  List fusers = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ChatCubit()
        ..getUsers()
        ..getUsersAll(),
      child: Builder(builder: (BuildContext context) {
        return BlocConsumer<ChatCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is SocialGetAllUserLoadingStates) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (ChatCubit.get(context).users.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'There is no users in your contacts using this app',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            return Scaffold(
              body: Container(
                color:isDark?Color(0): Color(0xFFECF0F3),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: ChatCubit.get(context).users.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => INK(
                    ChatCubit.get(context).users[index],
                    context,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget INK(UsersModel users, context) => InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailes(users),
            ),
          );
          ChatCubit.get(context).scrolltoDown();
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              CircleAvatar(
                radius: 45,
                backgroundImage: NetworkImage(
                  users.profilePicturePrivacy != 'No Body'
                      ? users.ImageProfile.toString()
                      : defaultProrfilePictures,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                children: [
                  Text(
                    users.name.toString(),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
